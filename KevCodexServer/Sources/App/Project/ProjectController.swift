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
        
        let apiKeyMiddleware = ApiKeyMiddleware(apiKey: apiKey)
        
        let authenticationRouter = apiRouter.grouped(JWTMiddleware(), apiKeyMiddleware)

        authenticationRouter.put(ObjectId.parameter, use: editItemByObjectID)
        authenticationRouter.post(use: addItem)
        authenticationRouter.delete(ObjectId.parameter, use: deleteItemByObjectID)
    }
    
    func getAllItems(_ req: Request) throws -> Future<[Item]> {
        
        let context = try req.context()
        
        return context.find(Item.self).getAllResults().map({ (items) in
            return items.sorted {
                guard let firstOrder = $0.sortOrder,
                    let secondOrder = $1.sortOrder else {
                        return false
                }
                return firstOrder < secondOrder
            }
        })
    }
}
