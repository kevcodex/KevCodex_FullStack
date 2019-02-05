//
//  Token.swift
//  App
//
//  Created by Kevin Chen on 2/4/19.
//

import Vapor
import JWT

struct Token: Codable {
    let uid: UUID
    let exp: TimeInterval
}

extension Token: JWTPayload {
    func verify(using signer: JWTSigner) throws {
        guard exp >= Date().timeIntervalSince1970 else {
            throw Abort(.unauthorized, reason: "Token has expired")
        }
    }
}

extension Token {
    static func generate(for user: User) -> Token {
        
        #if DEBUG
        let expiration = Date.distantFuture.timeIntervalSince1970
        #else
        let expiration = Date().timeIntervalSince1970 + 259200
        #endif
        
        return Token(uid: user.id, exp: expiration)
    }
}
