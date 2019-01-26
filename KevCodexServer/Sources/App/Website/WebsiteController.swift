//
//  WebsiteController.swift
//  App
//
//  Created by Kevin Chen on 1/24/19.
//

import Vapor

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: indexPage)
        router.get("test", use: testHandler)
        router.get("foo", use: fooHandler)
        router.get("hiking", use: hikingPage)
    }
    
    func indexPage(_ req: Request) throws -> Future<View> {
        
        return try req.view().render("index")
    }
    
    func testHandler(_ req: Request) throws -> Future<View> {

        let context = IndexContext(title: "Homepage")
 
        return try req.view().render("test", context)
    }
    
    func fooHandler(_ req: Request) throws -> Future<View> {
        
        return try req.view().render("_pages/test")
    }
    
    func hikingPage(_ req: Request) throws -> Future<View> {
        
        let meow = req.meow()
        
        let futureHikes = meow.flatMap { (context) in
            return context.find(Hike.self).getAllResults()
        }
        
        return futureHikes.flatMap { (hikes) -> EventLoopFuture<View> in
            
            let hikesData = hikes.isEmpty ? nil : hikes
            
            let context = HikingContext(title: "Homepage", hikes: hikesData)
            
            return try req.view().render("hiking", context)
        }
    }
}

