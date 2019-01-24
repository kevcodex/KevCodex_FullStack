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
    let database: MongoKitten.Database
    
    var collection: MongoKitten.Collection {
        return database[config.collectionName]
    }
    
    var bsonDecoder: BSONDecoder = {
        return BSONDecoder()
    }()
    
    var bsonEncoder: BSONEncoder = {
        return BSONEncoder()
    }()
    
    init(config: MongoConfig, database: MongoKitten.Database) {
        self.config = config
        self.database = database
    }
    
    func findAll<T: Codable>() -> Future<[T]> {
        
        let all = self.collection.find().map { (document) in
            return try self.bsonDecoder.decode(T.self, from: document)
        }
        
        return all.getAllResults()
    }
}

extension Request {
    func mongoService() -> Future<MongoService> {
        return Future.flatMap(on: self) { try self.privateContainer.make(Future<MongoService>.self) }
    }
}
