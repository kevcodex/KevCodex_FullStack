//
//  MongoModelUpdateable.swift
//  App
//
//  Created by Kevin Chen on 1/31/19.
//

import Vapor
import MeowVapor

/// An item that can be updated.
/// Requires a Body type that will be used as the body for the request.
protocol MongoModelUpdateable where Self: MeowVapor.Model {
    associatedtype Body: Content
    
    func updateFields(with body: Body)
}
