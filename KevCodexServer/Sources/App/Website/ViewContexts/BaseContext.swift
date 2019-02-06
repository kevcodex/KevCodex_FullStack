//
//  BaseContext.swift
//  App
//
//  Created by Kevin Chen on 1/26/19.
//

import Foundation

protocol BaseContext where Self: Encodable {
    var navigation: [NavigationItem] { get }
    var title: String { get }
}

struct NavigationItem: Encodable {
    let isActive: Bool
    let path: String
    let title: String
}
