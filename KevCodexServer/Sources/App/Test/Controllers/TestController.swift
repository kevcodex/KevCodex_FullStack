import Vapor

struct TestController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api")
        apiRouter.get("hello", use: helloWorldHandler)
        apiRouter.get("beers", Int.parameter, use: beersHandler)
        
        apiRouter.get("mongo", use: testMongo)
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
}

