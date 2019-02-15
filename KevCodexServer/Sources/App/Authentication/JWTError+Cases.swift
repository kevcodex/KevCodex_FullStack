//
//  JWTError+Cases.swift
//  App
//
//  Created by Kevin Chen on 2/15/19.
//

import JWT

extension JWTError {
    static let verificationFailed = JWTError(identifier: "Token.verifyToken", reason: "JWT verification failed")
    static let tokenExpired = JWTError(identifier: "Token.tokenExpired", reason: "Token has expired")
}
