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
    
    func boot(router: Router) throws {
        let apiRouter = router.grouped("api", "profile")
        
        apiRouter.get("test", use: jwtTest)
//        apiRouter.post("register", use: registerHandler)
        apiRouter.post("login", use: loginHandler)
    }
    
    func jwtTest(_ req: Request) throws -> String {
        // fetches the token from `Authorization: Bearer <token>` header
        guard let bearer = req.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        
        // parse JWT from token string, using HS-256 signer
        let jwt = try JWT<Token>(from: bearer.token, verifiedUsing: .hs256(key: JWTConfig.key))
        return "Hello, \(jwt.payload.uid)!"
    }
    
    func registerHandler(_ req: Request) throws -> Future<User.Response> {
        
        return try req.content.decode(User.self).flatMap { (user) in
            
            let context = try req.context()
            
            let path = try User.makeQueryPath(for: \User.email)
            let futureExistingUser = context.findOne(User.self, where: path == user.email)
            
            return futureExistingUser.flatMap({ (existingUser) in
                if let _ = existingUser {
                    throw Abort(.conflict, reason: "Email already exists")
                } else {
                    
                    try user.encryptPassword()
                    let saveFuture = context.save(user)
                    
                    return saveFuture.map({ (_) -> User.Response in
                        let token = Token.generate(for: user)
                        
                        let signer = JWTConfig.signer
                        
                        let jwt = JWT(payload: token)
                        let data = try signer.sign(jwt)
                        
                        guard let tokenString = String(data: data, encoding: .utf8) else {
                            throw Abort(.badRequest)
                        }
                        
                        let response = user.convertToResponse(token: tokenString, expiration: token.exp)
                        
                        return response
                    })
                }
            })
        }
    }
    
    func loginHandler(_ req: Request) throws -> Future<User.Response> {
        
        return try req.content.decode(User.self).flatMap { (userBody) in
            
            let context = try req.context()
            
            let emailPath = try User.makeQueryPath(for: \User.email)
            
            let futureExistingUser = context.findOne(User.self, where: emailPath == userBody.email)
            
            return futureExistingUser.map({ (existingUser) in
                
                guard let existingUser = existingUser else {
                    throw Abort(.unauthorized, reason: "Invalid Email")
                }
                
                guard try User.verifyPassword(plainText: userBody.password, encryptedPass: existingUser.password) else {
                    throw Abort(.unauthorized, reason: "Invalid Password")
                }
                
                let token = Token.generate(for: existingUser)
                
                let signer = JWTConfig.signer
                
                let jwt = JWT(payload: token)
                let data = try signer.sign(jwt)
                
                guard let tokenString = String(data: data, encoding: .utf8) else {
                    throw Abort(.badRequest)
                }
                
                let response = existingUser.convertToResponse(token: tokenString, expiration: token.exp)
                
                return response
            })
        }
    }
}
