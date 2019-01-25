//
//  Game.swift
//  App
//
//  Created by Kevin Chen on 1/23/19.
//

import Vapor
import MeowVapor

/// Specifically just for decoding body in request
struct GameBody: Decodable {
    var name: String
    var description: String
    var image: String
    var date: String
    var developer: String?
}

final class Game: MeowVapor.Model, Content {
    var _id: ObjectId
    
    var name: String
    var description: String
    var image: String
    var date: String
    var developer: String?
    
    init(name: String,
         description: String,
         image: String,
         date: String,
         developer: String?) {
        
        self._id = ObjectId()
        self.name = name
        self.description = description
        self.image = image
        self.date = date
        self.developer = developer
    }
    
    static var collectionName: String {
        return "game"
    }
}
