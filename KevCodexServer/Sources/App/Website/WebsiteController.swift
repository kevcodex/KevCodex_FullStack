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
        router.get("hiking", use: hikingPage)
    }

    func indexPage(_ req: Request) throws -> Future<View> {
        let navigation = navigationStructure(for: req)
        let context = IndexContext(navigation: navigation, title: "Homepage")
        
        return try req.view().render("index", context)
    }
    
    func hikingPage(_ req: Request) throws -> Future<View> {
        
        let meow = req.meow()
        
        let futureHikes = meow.flatMap { (context) in
            return context.find(Hike.self).getAllResults()
        }
        
        return futureHikes.flatMap { (hikes) -> EventLoopFuture<View> in
            
            let hikesData = hikes.isEmpty ? nil : hikes
            
            let navigation = self.navigationStructure(for: req)
            let context = HikingContext(navigation: navigation, title: "Hiking", hikes: hikesData)
            
            return try req.view().render("hiking", context)
        }
    }
    
    private func navigationStructure(for req: Request) -> [NavigationItem] {
        
        let reqPath = req.http.url.path
        
        // Better way to define isActive?
        return [NavigationItem(isActive: reqPath == NavigationPath.home, path: NavigationPath.home, title: "Home"),
                NavigationItem(isActive: reqPath == NavigationPath.hiking, path: NavigationPath.hiking, title: "Hiking")]
    }
    
    private struct NavigationPath {
        static let home = "/"
        static let hiking = "/hiking"
        
        private init() {}
    }
}

