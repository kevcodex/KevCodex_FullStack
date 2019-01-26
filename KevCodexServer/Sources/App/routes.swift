import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    try router.register(collection: TestController())
    try router.register(collection: GameController())
    
    try router.register(collection: WebsiteController())
}
