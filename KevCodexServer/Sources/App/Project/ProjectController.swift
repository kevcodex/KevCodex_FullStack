//
//  ProjectController.swift
//  App
//
//  Created by Kevin Chen on 1/30/19.
//


import Vapor
import MongoKitten

struct ProjectController: RouteCollection, MongoQueryable {
    typealias Item = Project
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "projects")
        apiRouter.get(use: getAllItems)
        apiRouter.get(ObjectId.parameter, use: getItem)
        apiRouter.put(ObjectId.parameter, use: editProjectByObjectID)
        apiRouter.post(use: addItem)
        apiRouter.delete(ObjectId.parameter, use: deleteItemByObjectID)
    }
    
    func editProjectByObjectID(_ req: Request) throws -> Future<HTTPStatus> {
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == globalApiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        let projectFuture = try getItem(req)
        
        return try req.content.decode(ProjectUpdateBody.self).flatMap(to: HTTPStatus.self) { (body) in
            
            return projectFuture.flatMap({ (project) in
                
                project.updateFields(with: body)
                
                let meow = req.meow()
                
                return meow.flatMap { (context) -> Future<HTTPStatus> in
                    return context.save(project).transform(to: HTTPStatus.noContent)
                }
            })
        }
    }
}
