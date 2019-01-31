//
//  ProjectController.swift
//  App
//
//  Created by Kevin Chen on 1/30/19.
//

import Vapor
import MongoKitten

struct ProjectController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "projects")
        apiRouter.get(use: getAllProejcts)
    }
    
    func getAllProejcts(_ req: Request) throws -> Future<[Project]> {
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            return context.find(Project.self).getAllResults()
        }
    }
}
