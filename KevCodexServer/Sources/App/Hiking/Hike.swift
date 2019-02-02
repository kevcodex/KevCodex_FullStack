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
    
    var title: String
    var location: String
    var distance: Double
    var hikingTime: Double
    var elevationGain: Int
    var difficulty: String?
    var description: String
    var imageURLString: String?
    
    var shortDescription: String?
    
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
        self.imageURLString = try container.decodeIfPresent(String.self, forKey: .imageURLString)
        
        self.shortDescription = description.components(separatedBy: ".").first
    }
    
    static var collectionName: String {
        return "hiking"
    }
}

extension Hike: MongoModelUpdateable {
    func updateFields(with body: HikeUpdateBody) {
        if let title = body.title {
            self.title = title
        }
        
        if let location = body.location {
            self.location = location
        }
        
        if let distance = body.distance {
            self.distance = distance
        }
        
        if let hikingTime = body.hikingTime {
            self.hikingTime = hikingTime
        }
        
        if let elevationGain = body.elevationGain {
            self.elevationGain = elevationGain
        }
        
        if let difficulty = body.difficulty {
            self.difficulty = difficulty
        }
        
        if let description = body.description {
            self.description = description
            self.shortDescription = description.components(separatedBy: ".").first
        }
        
        if let imageURLString = body.imageURLString {
            self.imageURLString = imageURLString
        }
    }
}

/// The body to update the project. Contains all optional params to allow one or all project info to be updatable
struct HikeUpdateBody: Content {
    
    let title: String?
    let location: String?
    let distance: Double?
    let hikingTime: Double?
    let elevationGain: Int?
    let difficulty: String?
    let description: String?
    let imageURLString: String?
}

