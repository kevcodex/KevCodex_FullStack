//
//  Token.swift
//  App
//
//  Created by Kevin Chen on 2/4/19.
//

import Vapor
import JWT

struct Token: Codable {
    let id: UUID
    let expiration: TimeInterval
}

extension Token: JWTPayload {
    func verify(using signer: JWTSigner) throws {
        guard expiration >= Date().timeIntervalSince1970 else {
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
        
        return Token(id: user.id, expiration: expiration)
    }
}
