import Vapor
import MongoKitten
import MeowVapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    guard let uri = Environment.get("DB_URI") else {
        throw VaporError(identifier: "Mongo", reason: "Missing Mongo DB URI")
    }
    
    let config = MongoConfig(databaseURI: uri, collectionName: "game")
    
    /// Register providers first
    let test = MongoProvider(config: config)
    try services.register(test)
    
//    try services.register(try MeowProvider(uri))
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
}
