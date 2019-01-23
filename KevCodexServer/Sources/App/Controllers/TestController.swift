import Vapor

struct TestController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api")
        apiRouter.get("hello", use: helloWorldHandler)
    }
    
    func helloWorldHandler(_ req: Request) throws -> String {
        return "Hellooooo wooorrrlllddd"
    }

}
