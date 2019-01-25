//
//  GameController.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Vapor

struct GameController: RouteCollection {
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "games")
        apiRouter.get(use: getGames)
    }
    
    func getGames(_ req: Request) throws -> Future<[Game]> {
        let meow = req.meow()
        
        return meow.flatMap { (context) -> Future<[Game]> in
            
            return context.find(Game.self).getAllResults()
        }
    }
}
