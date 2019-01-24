//
//  MongoConfig.swift
//  App
//
//  Created by Kevin Chen on 1/23/19.
//

import Vapor

struct MongoConfig: Service {
    let databaseURI: String
    let collectionName: String
}
