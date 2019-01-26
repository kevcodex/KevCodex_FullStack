//
//  HikingContext.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Foundation

struct HikingContext: Encodable, BaseContext {
    let navigation: [NavigationItem]
    let title: String
    let hikes: [Hike]?
}
