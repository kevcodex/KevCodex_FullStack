//
//  Hike.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Vapor
import MeowVapor

/// Specifically just for decoding body in request
struct HikeBody: Decodable {
    let title: String
    let location: String
    let distance: Double
    let hikingTime: Double
    let elevationGain: Int
    let difficulty: String?
    let description: String
}

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
        
        self._id = ObjectId()
        self.title = try container.decode(String.self, forKey: .title)
        self.location = try container.decode(String.self, forKey: .title)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.hikingTime = try container.decode(Double.self, forKey: .hikingTime)
        self.elevationGain = try container.decode(Int.self, forKey: .elevationGain)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.description = try container.decode(String.self, forKey: .description)
        
        self.shortDescription = description.components(separatedBy: ".").first
    }
    
    init(title: String,
         location: String,
         distance: Double,
         hikingTime: Double,
         elevationGain: Int,
         difficulty: String?,
         description: String) {
        
        self._id = ObjectId()
        self.title = title
        self.location = location
        self.distance = distance
        self.hikingTime = hikingTime
        self.elevationGain = elevationGain
        self.difficulty = difficulty
        self.description = description
        
        self.shortDescription = description.components(separatedBy: ".").first
    }
    
    convenience init(hikeBody: HikeBody) {
        self.init(title: hikeBody.title, location: hikeBody.location, distance: hikeBody.distance, hikingTime: hikeBody.hikingTime, elevationGain: hikeBody.elevationGain, difficulty: hikeBody.difficulty, description: hikeBody.description)
    }
    
    static var collectionName: String {
        return "hiking"
    }
}
