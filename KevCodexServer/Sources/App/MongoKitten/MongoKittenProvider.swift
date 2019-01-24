//
//  MongoKittenProvider.swift
//  App
//
//  Created by Kevin Chen on 1/23/19.
//

import MongoKitten
import Vapor
import DatabaseKit

final class MongoProvider: Provider {
    
    private let config: MongoConfig
    
    init(config: MongoConfig) {
        self.config = config
    }
    
    func register(_ services: inout Services) throws {
        
        let mongoServiceFactory = BasicServiceFactory(Future<MongoService>.self, supports: []) { container in
            return MongoKitten.Database.connect(self.config.databaseURI, on: container.eventLoop).map({ (database) in
                MongoService(config: self.config, database: database)
            })
        }
        services.register(mongoServiceFactory)
    }
    
    func willBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    func didBoot(_ container: Container) throws -> Future<Void> {
        return .done(on: container)
    }
}
