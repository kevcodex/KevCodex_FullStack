//
//  AccessToken.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/12/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

struct AccessToken: Codable {
    let value: String
    let expiration: TimeInterval
    
    init(value: String, expiration: TimeInterval) {
        self.value = value
        self.expiration = expiration
    }
}
