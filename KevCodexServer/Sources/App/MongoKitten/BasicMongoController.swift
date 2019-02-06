//
//  BasicMongoController.swift
//  App
//
//  Created by Kevin Chen on 1/30/19.
//

import MeowVapor

/// The base controller that will create and handle routes for basic mongo DB requests.
class BasicMongoController<Item>: RouteCollection, MongoQueryable where Item: Content, Item: QueryableModel {
    
    let apiKey: String
    
    let path: [PathComponentsRepresentable]
    
    init(path: PathComponentsRepresentable..., apiKey: String) {
        self.path = path
        self.apiKey = apiKey
    }
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped(path)
        apiRouter.get(use: getAllItems)
        apiRouter.get(ObjectId.parameter, use: getItem)
        apiRouter.post(use: addItem)
        apiRouter.delete(ObjectId.parameter, use: deleteItemByObjectID)
    }
}
