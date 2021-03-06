//
//  GameController.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Vapor
import MongoKitten

struct GameController: RouteCollection {
    
    let apiKey: String
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "games")
        apiRouter.get(use: getGames)
        apiRouter.post(use: addGame)
        apiRouter.delete("name", String.parameter, use: deleteGame)
    }
    
    func getGames(_ req: Request) throws -> Future<[Game]> {
        let context = try req.context()
        
        return context.find(Game.self).getAllResults()
    }
    
    func addGame(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == self.apiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        return try req.content.decode(GameBody.self).flatMap(to: HTTPStatus.self) { (game) in
            
            let context = try req.context()
            
            let test = Game(name: game.name,
                            description: game.description,
                            image: game.image,
                            date: game.date,
                            developer: game.developer)
            
            let foo = context.save(test)
            
            return foo.transform(to: HTTPStatus.created)
        }
    }
    
    func deleteGame(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let apiKey = req.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == self.apiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        let name = try req.parameters.next(String.self)
        
        let context = try req.context()
        
        let namePath = try Game.makeQueryPath(for: \Game.name)
        let futureInt = context.deleteOne(Game.self, where: namePath == name)
        
        return futureInt.map { (int) -> (HTTPStatus) in
            return int == 1 ? .noContent : .notFound
        }
    }
}
