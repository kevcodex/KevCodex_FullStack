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
    
    let apiKey: String
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "projects")
        apiRouter.get(use: getAllItems)
        apiRouter.get(ObjectId.parameter, use: getItem)
        apiRouter.put(ObjectId.parameter, use: editItemByObjectID)
        apiRouter.post(use: addItem)
        apiRouter.delete(ObjectId.parameter, use: deleteItemByObjectID)
    }
}
