//
//  Test.swift
//  App
//
//  Created by Kevin Chen on 1/22/19.
//

import Vapor

struct Test: Content {
    var json: Bool?
}

struct Beer: Content {
    let message: String
}
