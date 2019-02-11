//
//  User.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/11/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

struct User: Decodable {
    let accessToken: String
    let expiration: TimeInterval
    let id: UUID
    let email: String
}
