//
//  JWTMiddleware.swift
//  App
//
//  Created by Kevin Chen on 2/15/19.
//

import Vapor
import JWT

struct JWTMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        guard let bearerAuth = request.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized, reason: "Missing Access Token")
        }
        
        do {
            try Token.verifySignature(from: bearerAuth.token)
            
            return try next.respond(to: request)
        } catch let error as JWTError {
            throw Abort(.unauthorized, reason: error.reason)
        }
    }
}
