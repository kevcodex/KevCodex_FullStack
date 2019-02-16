//
//  Hike.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

struct Hike: Codable {
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
