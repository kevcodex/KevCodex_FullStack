//
//  TestContext.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Vapor

struct TestContext: Encodable, BaseContext {
    let navigation: [NavigationItem]
    let title: String
}
