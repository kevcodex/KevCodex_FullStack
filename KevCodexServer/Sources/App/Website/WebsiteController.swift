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
        router.get("about", use: aboutMePage)
    }

    func indexPage(_ req: Request) throws -> Future<View> {
        let navigation = leftNavigationStructure(for: req)
        let context = IndexContext(navigation: navigation, title: "Homepage")
        
        return try req.view().render("index", context)
    }
    
    func hikingPage(_ req: Request) throws -> Future<View> {
                
        let futureHikes = try HikingController().getAllHikes(req)
        
        return futureHikes.flatMap { (hikes) -> Future<View> in
            
            let hikesData = hikes.isEmpty ? nil : hikes
            
            let navigation = self.leftNavigationStructure(for: req)
            let context = HikingContext(navigation: navigation, title: "Hiking", hikes: hikesData)
            
            return try req.view().render("hiking", context)
        }
    }
    
    func aboutMePage(_ req: Request) throws -> Future<View> {
        let navigation = leftNavigationStructure(for: req)
        let context = AboutContext(navigation: navigation, title: "About Me")
        
        return try req.view().render("about", context)
    }
    
    private func leftNavigationStructure(for req: Request) -> [NavigationItem] {
        
        let reqPath = req.http.url.path
        
        // Better way to define isActive?
        let home = NavigationItem(isActive: reqPath == NavigationPath.home, path: NavigationPath.home, title: "Home")
        let hiking = NavigationItem(isActive: reqPath == NavigationPath.hiking, path: NavigationPath.hiking, title: "Hiking")
        
        let about = NavigationItem(isActive: reqPath == NavigationPath.about, path: NavigationPath.about, title: "About Me")
        
        return [home,
                about,
                hiking]
    }
    
    private struct NavigationPath {
        static let home = "/"
        static let hiking = "/hiking"
        static let about = "/about"
        
        private init() {}
    }
}

