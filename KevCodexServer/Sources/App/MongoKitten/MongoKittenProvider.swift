//
//  MongoKittenProvider.swift
//  App
//
//  Created by Kevin Chen on 1/23/19.
//

import MongoKitten
import Vapor
import DatabaseKit

// Works but doesn't feel correct, don't use until I figure out how to make it work
final class MongoProvider: Provider {
    
    private let config: MongoConfig
    
    init(config: MongoConfig) {
        self.config = config
    }
    
    // Not sure if what i am doing is "correct"
    func register(_ services: inout Services) throws {
        let threadPool = BlockingIOThreadPool(numberOfThreads: 4)
        threadPool.start()
        
        let mongo = MongoService(config: config, threadPool: threadPool)
        
        services.register(mongo)
    }
    
    func willBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    func didBoot(_ container: Container) throws -> Future<Void> {
        
        let mongo = try container.make(MongoService.self)
        return try mongo.connect(on: container.eventLoop)
    }
    
}
