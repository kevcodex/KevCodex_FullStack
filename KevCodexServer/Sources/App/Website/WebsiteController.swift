//
//  WebsiteController.swift
//  App
//
//  Created by Kevin Chen on 1/24/19.
//

import Vapor

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.get("test", use: testHandler)
        router.get("foo", use: fooHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        
        return try req.view().render("index")
    }
    
    func testHandler(_ req: Request) throws -> Future<View> {

        let context = IndexContext(title: "Homepage")
 
        return try req.view().render("test", context)
    }
    
    func fooHandler(_ req: Request) throws -> Future<View> {
        
        return try req.view().render("_pages/test")
    }
}

struct IndexContext: Encodable {
    let title: String
}

