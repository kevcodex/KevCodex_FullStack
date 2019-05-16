//
//  MongoQueryable.swift
//  App
//
//  Created by Kevin Chen on 1/30/19.
//

import Vapor
import MeowVapor

/// Simple implementation of some requests that make calls to mongo
public protocol MongoQueryable {
    associatedtype Item: Content, QueryableModel
}

extension MongoQueryable {
    public func getAllItems(_ req: Request) throws -> Future<[Item]> {
        
        let context = try req.context()
        
        return context.find(Item.self).getAllResults()
    }
    
    public func getItem(_ req: Request) throws -> Future<Item> {
        
        var id: ObjectId
        
        do {
            id = try req.parameters.next(ObjectId.self)
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }
        
        let context = try req.context()
        
        return context.findOne(Item.self, where: "_id" == id).unwrap(or: Abort(.notFound))
    }
    
    public func addItem(_ req: Request) throws -> Future<HTTPStatus> {
        
        return try req.content.decode(Item.self).flatMap(to: HTTPStatus.self) { (item) in
            
            let context = try req.context()
            
            return context.save(item).transform(to: HTTPStatus.created)
        }
    }
    
    public func deleteItemByObjectID(_ req: Request) throws -> Future<HTTPStatus> {
        
        let id = try req.parameters.next(ObjectId.self)
        
        let context = try req.context()
        
        let futureInt = context.deleteOne(Item.self, where: "_id" == id)
        
        return futureInt.map { (int) -> (HTTPStatus) in
            return int == 1 ? .noContent : .notFound
        }
    }
}

extension MongoQueryable where Item: MongoModelUpdateable {
    func editItemByObjectID(_ req: Request) throws -> Future<HTTPStatus> {
        
        let itemFuture = try getItem(req)
        
        return try req.content.decode(Item.Body.self).flatMap(to: HTTPStatus.self) { (body) in
            
            return itemFuture.flatMap({ (item) in
                
                item.updateFields(with: body)
                
                let context = try req.context()
                
                return context.save(item).transform(to: HTTPStatus.noContent)
            })
        }
    }
}
