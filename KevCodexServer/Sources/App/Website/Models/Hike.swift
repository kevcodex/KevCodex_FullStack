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
    let location: String
    let distance: Double
    let hikingTime: Double
    let elevationGain: Int
    let difficulty: String?
    let description: String
    
    let shortDescription: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._id = try container.decodeIfPresent(ObjectId.self, forKey: ._id) ?? ObjectId()
        self.title = try container.decode(String.self, forKey: .title)
        self.location = try container.decode(String.self, forKey: .title)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.hikingTime = try container.decode(Double.self, forKey: .hikingTime)
        self.elevationGain = try container.decode(Int.self, forKey: .elevationGain)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.description = try container.decode(String.self, forKey: .description)
        
        self.shortDescription = description.components(separatedBy: ".").first
    }
    
    static var collectionName: String {
        return "hiking"
    }
}
