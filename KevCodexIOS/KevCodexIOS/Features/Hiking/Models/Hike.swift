//
//  Hike.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

struct Hike: Codable {
    var _id: String?
    var title: String
    var location: String
    var distance: Double
    var hikingTime: Double
    var elevationGain: Int
    var difficulty: String?
    var description: String
    var imageURLString: String?
    
    var shortDescription: String?
}

extension Hike {
    
    struct UpdateBody: Codable {
        
        let title: String?
        let location: String?
        let distance: Double?
        let hikingTime: Double?
        let elevationGain: Int?
        let difficulty: String?
        let description: String?
        let imageURLString: String?
        
        func mapToHike() -> Hike? {
            guard let title = title,
                let location = location,
                let distance = distance,
                let hikingTime = hikingTime,
                let elevationGain = elevationGain,
                let difficulty = difficulty,
                let description = description,
                let imageURLString = imageURLString else {
                    
                    return nil
            }
            
            return Hike(_id: nil, title: title, location: location, distance: distance, hikingTime: hikingTime, elevationGain: elevationGain, difficulty: difficulty, description: description, imageURLString: imageURLString, shortDescription: nil)
        }
    }
}
