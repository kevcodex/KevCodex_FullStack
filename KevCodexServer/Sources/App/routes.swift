import Vapor

/// Register your application's routes here.
public func routes(_ router: Router, apiKey: String) throws {
    
    try router.register(collection: TestController(apiKey: apiKey))
    try router.register(collection: GameController(apiKey: apiKey))
    try router.register(collection: HikingController(apiKey: apiKey))
    
    try router.register(collection: ProjectController(apiKey: apiKey))
    
    try router.register(collection: WebsiteController(apiKey: apiKey))
}
