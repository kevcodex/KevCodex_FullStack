//
//  MongoQueryable.swift
//  App
//
//  Created by Kevin Chen on 1/30/19.
//

import Vapor
import MeowVapor

protocol MongoQueryable {
    associatedtype Item: Content, QueryableModel
}

extension MongoQueryable {
    func getAllItems(_ req: Request) throws -> Future<[Item]> {
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            return context.find(Item.self).getAllResults()
        }
    }
    
    func getItem(_ req: Request) throws -> Future<Item> {
        
        var id: ObjectId
        
        do {
            id = try req.parameters.next(ObjectId.self)
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            return context.findOne(Item.self, where: "_id" == id).unwrap(or: Abort(.notFound))
        }
    }
    
    func addItem(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == globalApiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        return try req.content.decode(Item.self).flatMap(to: HTTPStatus.self) { (item) in
            
            let meow = req.meow()
            
            return meow.flatMap { (context) -> Future<HTTPStatus> in
                return context.save(item).transform(to: HTTPStatus.created)
            }
        }
    }
    
    func deleteItemByObjectID(_ req: Request) throws -> Future<HTTPStatus> {
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == globalApiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        let id = try req.parameters.next(ObjectId.self)
        
        let meow = req.meow()
        
        let futureInt = meow.flatMap { (context) -> Future<Int> in
            return context.deleteOne(Hike.self, where: "_id" == id)
        }
        
        return futureInt.map { (int) -> (HTTPStatus) in
            return int == 1 ? .noContent : .notFound
        }
    }
}
