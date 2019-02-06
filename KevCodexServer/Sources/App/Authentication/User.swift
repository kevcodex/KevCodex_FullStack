//
//  User.swift
//  App
//
//  Created by Kevin Chen on 2/4/19.
//

import Vapor
import MeowVapor
import Crypto

final class User: QueryableModel {
    var _id: ObjectId
    
    // Gets stored as a string I think. Need to look into different storage
    let id: UUID
    let email: String
    var password: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode if present to accomadate both json decode and bson decode
        self._id = try container.decodeIfPresent(ObjectId.self, forKey: ._id) ?? ObjectId()
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
    }
    
    init(email: String, password: String) {
        self._id = ObjectId()
        self.id = UUID()
        
        self.email = email
        self.password = password
    }
    
    func encryptPassword() throws {
        password = try BCrypt.hash(password)
    }
    
    static func verifyPassword(plainText: String, encryptedPass: String) throws -> Bool {
        return try BCrypt.verify(plainText, created: encryptedPass)
    }
    
    static var collectionName: String {
        return "users"
    }
}

extension User {
    
    struct Response: Content {
        let accessToken: String
        let expiration: TimeInterval
        let id: UUID
        let email: String
    }
}

extension User {
    func convertToResponse(token: String, expiration: TimeInterval) -> User.Response {
        return User.Response(accessToken: token, expiration: expiration, id: id, email: email)
    }
}

extension Future where T: User {
    func convertToResponse(token: String, expiration: TimeInterval) -> Future<User.Response> {
        return self.map(to: User.Response.self) { user in
            return user.convertToResponse(token: token, expiration: expiration)
        }
    }
}
