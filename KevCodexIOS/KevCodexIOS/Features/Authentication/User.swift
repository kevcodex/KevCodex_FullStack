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
    
    func isValidAccessToken() -> Bool {
        guard expiration >= Date().timeIntervalSince1970 else {
            return false
        }
        
        return true
    }
}

extension User {
    
    static func store(user: User) {
        guard let data = try? JSONEncoder().encode(user) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: Key.user)
    }
    
    static func retrieve() -> User? {
        guard let data = UserDefaults.standard.data(forKey: Key.user),
            let user = try? JSONDecoder().decode(User.self, from: data) else {
                return nil
        }
        
        return user
    }
    
    static func removeCache() {
        UserDefaults.standard.removeObject(forKey: Key.user)
    }
}

// MARK: Keys
private extension User {
    struct Key {
        static let user = "user"
        private init() {}
    }
}
