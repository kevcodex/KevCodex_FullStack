//
//  Hike.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Vapor
import MeowVapor

final class Hike: Content, QueryableModel {
    var _id: ObjectId
    
    let title: String
    let description: String
    
    static var collectionName: String {
        return "hiking"
    }
}
