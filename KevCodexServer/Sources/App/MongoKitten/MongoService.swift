//
//  MongoService.swift
//  App
//
//  Created by Kevin Chen on 1/23/19.
//

import Vapor
import MongoKitten

class MongoService: Service {
    let config: MongoConfig
    var database: MongoKitten.Database!
    
    var collection: MongoKitten.Collection!
    
    private let threadPool: BlockingIOThreadPool
    
    init(config: MongoConfig, threadPool: BlockingIOThreadPool) {
        self.config = config
        self.threadPool = threadPool
    }
    
    func connect(on eventLoop: EventLoop) throws -> Future<Void> {
        let databaseFuture = MongoKitten.Database.connect(config.databaseURI, on: eventLoop)

        return databaseFuture.map { (database) -> (Void) in
            self.database = database
            self.collection = database[self.config.collectionName]
        }.catchMap { (error) -> (Void) in
            throw error
        }
    }
    
    func findAll(on eventLoop: EventLoop) -> Future<String> {
        
        
        return threadPool.runIfActive(eventLoop: eventLoop) {
            
            let all = self.collection.find().getAllResults()
            
            let test =  all.map { (element) -> (String) in
                return element.description
            }
            
            return try test.wait()
        }
    }
}
