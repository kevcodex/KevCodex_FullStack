//
//  HikingController.swift
//  App
//
//  Created by Kevin Chen on 1/26/19.
//

import Vapor

struct HikingController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "hikes")
        apiRouter.get(use: getAllHikes)
    }
    
    func getAllHikes(_ req: Request) throws -> Future<[Hike]> {
        
        let meow = req.meow()
        
        return meow.flatMap { (context) in
            return context.find(Hike.self).getAllResults()
        }
    }

}
