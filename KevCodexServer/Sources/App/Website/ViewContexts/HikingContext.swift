//
//  HikingContext.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Foundation

struct HikingContext: Encodable {
    let title: String
    let hikes: [Hike]?
}
