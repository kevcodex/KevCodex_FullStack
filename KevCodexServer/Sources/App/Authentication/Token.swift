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
            throw Abort(.unauthorized, reason: JWTError.tokenExpired.reason)
        }
    }
}

extension Token {
    
    static func verifySignature(from token: String) throws {
        do {
            let _ = try JWT<Token>(from: token, verifiedUsing: JWTConfig.signer)
        } catch {
            throw JWTError.verificationFailed
        }
    }
    
    static func generate(for user: User) -> Token {
        
        #if DEBUG
        let expiration = Date.distantFuture.timeIntervalSince1970
        #else
        let expiration = Date().timeIntervalSince1970 + 259200
        #endif
        
        return Token(uid: user.id, exp: expiration)
    }
}
