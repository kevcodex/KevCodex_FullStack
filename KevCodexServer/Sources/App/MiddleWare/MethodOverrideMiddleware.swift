//
//  MethodOverrideMiddleware.swift
//  App
//
//  Created by Kevin Chen on 1/25/19.
//

import Vapor

struct MethodOverrideMiddleware: Middleware, ServiceType {
    static func makeService(for worker: Container) throws -> MethodOverrideMiddleware {
        return .init()
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        guard let methodOverride = try? request.query.decode(MethodOverride.self),
            let newHTTPMethod = httpMethod(from: methodOverride.method.uppercased()) else {
                
                return try next.respond(to: request)
        }
        
        request.http.method = newHTTPMethod
        
        return try next.respond(to: request)
    }
    
    private func httpMethod(from string: String) -> HTTPMethod? {
        switch string {
        case "OPTIONS":
            return .OPTIONS
        case "GET":
            return .GET
        case "HEAD":
            return .HEAD
        case "POST":
            return .POST
        case "PATCH":
            return .PATCH
        case "PUT":
            return .PUT
        case "DELETE":
            return .DELETE
        case "TRACE":
            return .TRACE
        case "CONNECT":
            return .CONNECT
        default:
            return nil
        }
    }
}

struct MethodOverride: Decodable {
    let method: String
    
    enum CodingKeys: String, CodingKey {
        case method = "_method"
    }
}


