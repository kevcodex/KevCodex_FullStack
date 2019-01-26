import Vapor
import MongoKitten
import MeowVapor
import Leaf

// Temp
let globalApiKey = "27a9bec8-aa92-4a3f-800f-7618637d14a6"

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    guard let uri = Environment.get("DB_URI") else {
        throw VaporError(identifier: "Mongo", reason: "Missing Mongo DB URI")
    }
    
    // Register providers first
//    let config = MongoConfig(databaseURI: uri, collectionName: "game")
//
//
//    let test = MongoProvider(config: config)
//    try services.register(test)
    
    // For now go with using meow rather than self built provider
    // We'll see if issues occur down the line
    try services.register(try MeowProvider(uri))
    
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    services.register(MethodOverrideMiddleware.self)
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewaresConfig = MiddlewareConfig() // Create _empty_ middleware config
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)
}
