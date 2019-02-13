//
//  User.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/11/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

struct User: Codable {
    let accessToken: String
    let expiration: TimeInterval
    let id: UUID
    let email: String
}

extension User {
    
    static func cache(user: User) {
        guard let data = try? JSONEncoder().encode(user) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: Key.user)
    }
    
    static func retrieveUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: Key.user),
            let user = try? JSONDecoder().decode(User.self, from: data) else {
                return nil
        }
        
        return user
    }
}

// MARK: Keys
private extension User {
    struct Key {
        static let user = "user"
        private init() {}
    }
}
