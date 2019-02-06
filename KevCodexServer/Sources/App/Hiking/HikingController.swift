//
//  HikingController.swift
//  App
//
//  Created by Kevin Chen on 1/26/19.
//

import Vapor
import MongoKitten

struct HikingController: RouteCollection, MongoQueryable {
    
    typealias Item = Hike
    
    let apiKey: String
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "hikes")
        apiRouter.get(use: getAllItems)
        apiRouter.get(ObjectId.parameter, use: getItem)
        apiRouter.put(ObjectId.parameter, use: editItemByObjectID)
        apiRouter.post(use: addItem)
        apiRouter.delete(ObjectId.parameter, use: deleteItemByObjectID)
        apiRouter.delete("title", String.parameter, use: deleteHikeByTitle)
    }
    
    func deleteHikeByTitle(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let _ = req.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized, reason: "Missing Access Token")
        }
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == self.apiKey else {
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
