//
//  Credentials.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/11/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

struct Credentials {
    var username: String
    var password: String
    
    func isValid() -> Bool {
        guard !username.isEmpty, !password.isEmpty else {
            return false
        }
        
        return true
    }
}
