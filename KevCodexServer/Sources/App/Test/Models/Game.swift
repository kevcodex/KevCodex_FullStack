//
//  Game.swift
//  App
//
//  Created by Kevin Chen on 1/23/19.
//

import Vapor
import MeowVapor

// Only for if I want to conver the mongo object into some other object
//struct Game: Content {
//    var id: String
//    var name: String
//    var description: String
//    var image: String
//    var date: String
//    var developer: String
//
//    init(meow: MeowGame) {
//        self.id = meow._id.description
//        self.name = meow.name
//        self.description = meow.description
//        self.image = meow.image
//        self.date = meow.date
//        self.developer = meow.developer
//    }
//}

final class Game: MeowVapor.Model, Content {
    var _id: ObjectId
    
    var name: String
    var description: String
    var image: String
    var date: String
    var developer: String
    
    static var collectionName: String {
        return "game"
    }
}
