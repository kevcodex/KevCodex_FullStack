import Vapor
import MeowVapor

struct TestController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api")
        apiRouter.get("hello", use: helloWorldHandler)
        apiRouter.get("beers", Int.parameter, use: beersHandler)
        
        apiRouter.get("mongo", use: testMongo)
        
        apiRouter.get("meow", use: testMeow)
        apiRouter.get("meows", use: testMeows)
        
        apiRouter.post("addmeow", use: addMeow)
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
    
    func testMongo(_ req: Request) throws -> Future<String> {
        let test = try req.make(MongoService.self)
        
        return test.findAll(on: req.eventLoop)
    }
    
    func testMeow(_ req: Request) throws -> Future<Game> {
        let meow = req.meow()
        
        return meow.flatMap { (context) -> Future<Game> in
            let foo = context.find(Game.self).getFirstResult()
            
            return foo.unwrap(or: Abort(.badRequest, reason: "No game exists"))
        }
    }
    
    func testMeows(_ req: Request) throws -> Future<[Game]> {
        let meow = req.meow()
        
        return meow.flatMap { (context) -> Future<[Game]> in
            return context.find(Game.self).getAllResults()
        }
    }
    
    func addMeow(_ req: Request) throws -> Future<HTTPStatus> {
        let meow = req.meow()
        
        let test = meow.map { (context) -> Future<Void> in
            let test = Game()
            return context.save(test)
        }
        
        return test.transform(to: HTTPStatus.ok)
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

