import Vapor
import MeowVapor
import JWT
import Crypto

struct TestController: RouteCollection {
    
    let apiKey: String
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "test")
        apiRouter.get("hello", use: helloWorldHandler)
        apiRouter.get("beers", Int.parameter, use: beersHandler)
        apiRouter.get("header", use: testHeader)
        apiRouter.put("testput", use: testPutGames)
        
        apiRouter.get("mongo", use: testMongo)
        
        apiRouter.get("meow", use: testMeow)
        apiRouter.get("meowstatus", use: testMeowStatus)
        apiRouter.get("meows", use: testMeows)
        
        apiRouter.post("addmeow", use: addMeow)
        
        apiRouter.get("jwt", use: jwtTest)
        apiRouter.post("jwt", "register", use: createJWTTest)
        apiRouter.post("jwt", "login", use: loginTest)
    }
    
    func helloWorldHandler(_ req: Request) throws -> String {
        return "Hellooooo wooorrrlllddd"
    }
    
    func beersHandler(_ req: Request) throws -> AnyResponse {
        let numBeersInt = try req.parameters.next(Int.self)
        
        let queries = try req.query.decode(Test.self)
        
        if let _ = queries.json {
            
            return AnyResponse(Beer(message: "Take one down, pass it around, \(numBeersInt - 1) bottles of beer on the wall..."))
        } else {
            return AnyResponse("Take one down, pass it around, \(numBeersInt - 1) bottles of beer on the wall...")
        }
    }
    
    func testHeader(_ req: Request) throws -> String {
        let test = req.http.headers.firstValue(name: HTTPHeaderName("apikey"))
        
        return test?.description ?? "mising"
    }

    // Test routing middleware works
    func testPutGames(_ req: Request) throws -> String {
        return "Success"
    }
    
    func testMongo(_ req: Request) throws -> Future<[Game]> {
        let test = req.mongoService()
        
        return test.flatMap { (service) -> (Future<[Game]>) in
            return service.findAll()
        }
    }
    
    func testMeow(_ req: Request) throws -> Future<Game> {
        let meow = req.meow()
        
        return meow.flatMap { (context) -> Future<Game> in
            let foo = context.find(Game.self).getFirstResult()
            
            return foo.unwrap(or: Abort(.badRequest, reason: "No game exists"))
        }
    }
    
    // Modify response status and other
    func testMeowStatus(_ req: Request) throws -> Future<Response> {
        let meow = req.meow()
        
        return meow.flatMap { (context) -> (Future<Response>) in
            let foo = context.find(Game.self).getFirstResult()
            
            let bar = foo.unwrap(or: Abort(.badRequest, reason: "No game exists")).map({ (game) -> (Response) in
                let response = req.response(http: HTTPResponse(status: .accepted))
                try response.content.encode(game)
                
                return response
            })
            
            return bar
        }
    }
    
    func testMeows(_ req: Request) throws -> Future<[Game]> {
        let meow = req.meow()
        
        return meow.flatMap { (context) -> Future<[Game]> in
            
            return context.find(Game.self).getAllResults()
        }
    }
    
    func addMeow(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing Header")
        }
        
        guard apiKey == self.apiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        return try req.content.decode(GameBody.self).flatMap(to: HTTPStatus.self) { (game) in
            
            let meow = req.meow()
            
            let test = meow.map { (context) -> Future<Void> in
                let test = Game(name: game.name,
                                description: game.description,
                                image: game.image,
                                date: game.date,
                                developer: game.developer)
                
                return context.save(test)
            }
            
            return test.transform(to: HTTPStatus.created)
        }
    }
    
    func jwtTest(_ req: Request) throws -> String {
        // fetches the token from `Authorization: Bearer <token>` header
        guard let bearer = req.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        // parse JWT from token string, using HS-256 signer
        let jwt = try JWT<Token>(from: bearer.token, verifiedUsing: .hs256(key: "secret"))
        return "Hello, \(jwt.payload.uid)!"
    }
    
    func createJWTTest(_ req: Request) throws -> Future<User.Response> {
        
        return try req.content.decode(User.self).flatMap { (user) in
            
            let meow = req.meow()
            
            let futureExistingUser = meow.flatMap({ (context) -> Future<User?> in
                let path = try User.makeQueryPath(for: \User.email)
                return context.findOne(User.self, where: path == user.email)
            })
            
            return futureExistingUser.flatMap({ (existingUser) in
                if let _ = existingUser {
                    throw Abort(.conflict, reason: "Email already exists")
                } else {
                    
                    let saveFuture = meow.flatMap({ (context) in
                        return context.save(user)
                    })

                    return saveFuture.map({ (_) -> User.Response in
                        let token = Token.generate(for: user)
                        
                        let data = try JWT(payload: token).sign(using: .hs256(key: "secret"))
                        
                        guard let tokenString = String(data: data, encoding: .utf8) else {
                            throw Abort(.badRequest)
                        }
                        
                        let response = user.convertToResponse(token: tokenString, expiration: token.exp)
                        
                        return response
                    })
                }
            })
        }
    }
    
    func loginTest(_ req: Request) throws -> Future<User.Response> {
        
        return try req.content.decode(User.self).flatMap { (user) in
            
            let meow = req.meow()
            
            let futureExistingUser = meow.flatMap({ (context) -> Future<User?> in
                let emailPath = try User.makeQueryPath(for: \User.email)
                let passwordPath = try User.makeQueryPath(for: \User.password)
                
                return context.findOne(User.self, where: emailPath == user.email && passwordPath == user.password)
            })
            
            return futureExistingUser.map({ (existingUser) in
                
                guard let existingUser = existingUser else {
                    throw Abort(.unauthorized, reason: "Invalid Credentials")
                }
                
                let token = Token.generate(for: existingUser)
                
                let data = try JWT(payload: token).sign(using: .hs256(key: "secret"))
                
                guard let tokenString = String(data: data, encoding: .utf8) else {
                    throw Abort(.badRequest)
                }
                
                let response = user.convertToResponse(token: tokenString, expiration: token.exp)
                
                return response
            })
        }
    }
    
    //    func testMeow(_ req: Request) throws -> Future<Game> {
    //        let meow = req.meow()
    //
    //        return meow.flatMap { (context) -> Future<Game> in
    //            let foo = context.find(MeowGame.self).getFirstResult()
    //
    //            let unwrapped = foo.unwrap(or: Abort(.badRequest, reason: "No game exists"))
    //
    //            return unwrapped.map({ (game) -> Game in
    //                return Game(meow: game)
    //            })
    //        }
    //    }
    //
    //    func testMeows(_ req: Request) throws -> Future<[Game]> {
    //        let meow = req.meow()
    //
    //        return meow.flatMap { (context) -> Future<[Game]> in
    //            let foo = context.find(MeowGame.self).getAllResults()
    //
    //            return foo.map({ (games) -> [Game] in
    //                return games.map { Game(meow: $0) }
    //            })
    //        }
    //    }
}

