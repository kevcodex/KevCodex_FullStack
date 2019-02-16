//
//  MainCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/12/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

/// The coordinator that handles the main part of the app
final class MainCoordinator: NSObject, CoordinatorWithChildren {
    var childCoordinators: [String: Any] = [:]
    
    let rootViewController: MainTabBarViewController
    
    private let user: User
    
    init(user: User) {
        self.user = user
        
        rootViewController = MainTabBarViewController.makeFromStoryboard()
        
        super.init()
        
        let project = ProjectCoordinator(user: user)
        project.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        
        let settings = SettingsCoordinator(user: user)
        settings.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
        
        addChild(coordinator: project)
        addChild(coordinator: settings)
        
        rootViewController.addChild(project.rootViewController)
        rootViewController.addChild(settings.rootViewController)
    }
}
