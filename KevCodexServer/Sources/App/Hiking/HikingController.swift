//
//  HikingController.swift
//  App
//
//  Created by Kevin Chen on 1/26/19.
//

import Vapor
import MongoKitten

struct HikingController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "hikes")
        apiRouter.get(use: getAllHikes)
        apiRouter.get(ObjectId.parameter, use: getHike)
        apiRouter.post(use: addHike)
        apiRouter.delete(ObjectId.parameter, use: deleteHikeByObjectID)
        apiRouter.delete("title", String.parameter, use: deleteHikeByTitle)
    }
    
    func getAllHikes(_ req: Request) throws -> Future<[Hike]> {
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            return context.find(Hike.self).getAllResults()
        }
    }
    
    func getHike(_ req: Request) throws -> Future<Hike> {
        
        var id: ObjectId
        
        do {
            id = try req.parameters.next(ObjectId.self)
        } catch {
            throw Abort(.badRequest, reason: error.localizedDescription)
        }
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            return context.findOne(Hike.self, where: "_id" == id).unwrap(or: Abort(.notFound))
        }
    }
    
    func addHike(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == globalApiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        return try req.content.decode(Hike.self).flatMap(to: HTTPStatus.self) { (hike) in
            
            let meow = req.meow()
            
            return meow.flatMap { (context) -> Future<HTTPStatus> in
                return context.save(hike).transform(to: HTTPStatus.created)
            }
        }
    }
    
    func deleteHikeByObjectID(_ req: Request) throws -> Future<HTTPStatus> {
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
    
    func deleteHikeByTitle(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == globalApiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        let name = try req.parameters.next(String.self)
        
        let meow = req.meow()
        
        let futureInt = meow.flatMap { (context) -> Future<Int> in
            let namePath = try Hike.makeQueryPath(for: \Hike.title)
            return context.deleteOne(Hike.self, where: namePath == name)
        }
        
        return futureInt.map { (int) -> (HTTPStatus) in
            return int == 1 ? .noContent : .notFound
        }
    }
}
