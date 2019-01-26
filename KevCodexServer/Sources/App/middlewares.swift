//
//  middlewares.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Vapor

public func middlewares(config: inout MiddlewareConfig) throws {
    
    config.use(FileMiddleware.self) // Serves files from `Public/` directory
    config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    config.use(MethodOverrideMiddleware.self)
}
