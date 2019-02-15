//
//  ApiKeyMiddleware.swift
//  App
//
//  Created by Kevin Chen on 2/15/19.
//

import Vapor

struct ApiKeyMiddleware: Middleware {
    
    let apiKey: String
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        guard let apiKey = request.http.headers["apiKey"].first else {
            throw Abort(.forbidden, reason: "Missing API Header")
        }
        
        guard apiKey == self.apiKey else {
            throw Abort(.forbidden, reason: "Invalid API Key")
        }
        
        return try next.respond(to: request)
    }
}
