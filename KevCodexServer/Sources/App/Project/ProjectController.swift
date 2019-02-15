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
        
        let jwtRequiredRouter = apiRouter.grouped(JWTMiddleware())
        jwtRequiredRouter.put(ObjectId.parameter, use: editItemByObjectID)
        jwtRequiredRouter.post(use: addItem)
        jwtRequiredRouter.delete(ObjectId.parameter, use: deleteItemByObjectID)
    }
    
    func getAllItems(_ req: Request) throws -> Future<[Item]> {
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            
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
}
