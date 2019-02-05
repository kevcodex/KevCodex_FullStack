//
//  UserController.swift
//  App
//
//  Created by Kevin Chen on 2/4/19.
//

import Vapor
import MeowVapor
import JWT
import Crypto


struct UserController: RouteCollection {
    
    let apiKey: String
    let secretToken: String
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "profile")
        
        apiRouter.get("test", use: jwtTest)
        apiRouter.post("register", use: registerHandler)
        apiRouter.post("login", use: loginHandler)
    }
    
    func jwtTest(_ req: Request) throws -> String {
        // fetches the token from `Authorization: Bearer <token>` header
        guard let bearer = req.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        // parse JWT from token string, using HS-256 signer
        let jwt = try JWT<Token>(from: bearer.token, verifiedUsing: .hs256(key: secretToken))
        return "Hello, \(jwt.payload.id)!"
    }
    
    func registerHandler(_ req: Request) throws -> Future<User.Response> {
        
        return try req.content.decode(User.self).flatMap { (user) in
            
            let meow = req.meow()
            
            let futureExistingUser = meow.flatMap({ (context) -> Future<User?> in
                let path = try User.makeQueryPath(for: \User.email)
                return context.findOne(User.self, where: path == user.email)
            })
            
            return futureExistingUser.flatMap({ (existingUser) in
                if let _ = existingUser {
                    throw Abort(.conflict, reason: "Email already exists")
                } else {
                    
                    let saveFuture = meow.flatMap({ (context) in
                        return context.save(user)
                    })
                    
                    return saveFuture.map({ (_) -> User.Response in
                        let token = Token.generate(for: user)
                        
                        let data = try JWT(payload: token).sign(using: .hs256(key: self.secretToken))
                        
                        guard let tokenString = String(data: data, encoding: .utf8) else {
                            throw Abort(.badRequest)
                        }
                        
                        let response = user.convertToResponse(token: tokenString, expiration: token.expiration)
                        
                        return response
                    })
                }
            })
        }
    }
    
    func loginHandler(_ req: Request) throws -> Future<User.Response> {
        
        return try req.content.decode(User.self).flatMap { (user) in
            
            let meow = req.meow()
            
            let futureExistingUser = meow.flatMap({ (context) -> Future<User?> in
                let emailPath = try User.makeQueryPath(for: \User.email)
                let passwordPath = try User.makeQueryPath(for: \User.password)
                
                return context.findOne(User.self, where: emailPath == user.email && passwordPath == user.password)
            })
            
            return futureExistingUser.map({ (existingUser) in
                
                guard let existingUser = existingUser else {
                    throw Abort(.unauthorized, reason: "Invalid Credentials")
                }
                
                let token = Token.generate(for: existingUser)
                
                let data = try JWT(payload: token).sign(using: .hs256(key: self.secretToken))
                
                guard let tokenString = String(data: data, encoding: .utf8) else {
                    throw Abort(.badRequest)
                }
                
                let response = existingUser.convertToResponse(token: tokenString, expiration: token.expiration)
                
                return response
            })
        }
    }
}
