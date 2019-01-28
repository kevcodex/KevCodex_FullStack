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
        apiRouter.post(use: addHike)
        apiRouter.delete("name", String.parameter, use: deleteHike)
    }
    
    func getAllHikes(_ req: Request) throws -> Future<[Hike]> {
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            return context.find(Hike.self).getAllResults()
        }
    }
    
    func addHike(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == globalApiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        return try req.content.decode(HikeBody.self).flatMap(to: HTTPStatus.self) { (hikeBody) in
            
            let meow = req.meow()
            
            let hikeFuture = meow.map { (context) -> Future<Void> in
                let hike = Hike(hikeBody: hikeBody)
                
                return context.save(hike)
            }
            
            return hikeFuture.transform(to: HTTPStatus.created)
        }
    }
    
    func deleteHike(_ req: Request) throws -> Future<HTTPStatus> {
        
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
