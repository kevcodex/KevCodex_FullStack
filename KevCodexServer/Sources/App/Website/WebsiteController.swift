//
//  WebsiteController.swift
//  App
//
//  Created by Kevin Chen on 1/24/19.
//

import Vapor
import MongoKitten

struct WebsiteController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get(use: aboutMePage)
        router.get("projects", use: projectsPage)
        router.get("hiking", use: hikingPage)
        router.get("hiking", ObjectId.parameter, use: hikingDetailPage)
        router.get("test", use: testPage)
    }

    func testPage(_ req: Request) throws -> Future<View> {
        let navigation = leftNavigationStructure(for: req)
        let context = TestContext(navigation: navigation, title: "Test")
        
        return try req.view().render("test", context)
    }
    
    func hikingPage(_ req: Request) throws -> Future<View> {
                
        let futureHikes = try HikingController().getAllHikes(req)
        
        return futureHikes.flatMap { (hikes) -> Future<View> in
            
            let hikesData = hikes.isEmpty ? nil : hikes
            
            let navigation = self.leftNavigationStructure(for: req)
            let context = HikingListContext(navigation: navigation, title: "Hiking", hikes: hikesData)
            
            return try req.view().render("hiking", context)
        }
    }
    
    func hikingDetailPage(_ req: Request) throws -> Future<View> {
        
        let futureHike = try HikingController().getHike(req)
        
        return futureHike.flatMap { (hike) -> Future<View> in
            
            let context = HikingDetailContext(title: hike.title, hike: hike)
            
            return try req.view().render("hikingDetail", context)
        }
    }
    
    func aboutMePage(_ req: Request) throws -> Future<View> {
        let navigation = leftNavigationStructure(for: req)
        let context = AboutContext(navigation: navigation, title: "About Me")
        
        return try req.view().render("about", context)
    }
    
    func projectsPage(_ req: Request) throws -> Future<View> {
        let navigation = leftNavigationStructure(for: req)
        let context = ProjectsContext(navigation: navigation, title: "Projects")
        
        return try req.view().render("projects", context)
    }
    
    private func leftNavigationStructure(for req: Request) -> [NavigationItem] {
        
        let reqPath = req.http.url.path
        
        // Better way to define isActive?
        let home = NavigationItem(isActive: reqPath == NavigationPath.home, path: NavigationPath.home, title: "About Me")
        let projects = NavigationItem(isActive: reqPath == NavigationPath.projects, path: NavigationPath.projects, title: "Projects")
        let hiking = NavigationItem(isActive: reqPath == NavigationPath.hiking, path: NavigationPath.hiking, title: "Hiking")
        
        return [home,
                projects,
                hiking]
    }
    
    private struct NavigationPath {
        static let home = "/"
        static let hiking = "/hiking"
        static let projects = "/projects"
        
        private init() {}
    }
}

