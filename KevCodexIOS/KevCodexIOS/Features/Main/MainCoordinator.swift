//
//  MainCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/12/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol MainCoordinatorDelegate: class {
    func mainCoordinatorDidLogout(_ mainCoordinator: MainCoordinator)
}

/// The coordinator that handles the main part of the app
final class MainCoordinator: NSObject, CoordinatorWithChildren {
    var childCoordinators: [String: Any] = [:]
    
    let rootViewController: MainTabBarViewController
    
    weak var delegate: MainCoordinatorDelegate?
    
    private let user: User
    
    init(user: User, delegate: MainCoordinatorDelegate) {
        self.user = user
        self.delegate = delegate
        
        rootViewController = MainTabBarViewController.makeFromStoryboard()
        
        super.init()
        
        let hiking = HikingCoordinator(user: user)
        hiking.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        
        let project = ProjectCoordinator(user: user)
        project.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        
        let settings = SettingsCoordinator(user: user, delegate: self)
        settings.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        addChild(coordinator: hiking)
        addChild(coordinator: project)
        addChild(coordinator: settings)
        
        rootViewController.addChild(hiking.rootViewController)
        rootViewController.addChild(project.rootViewController)
        rootViewController.addChild(settings.rootViewController)
    }
}

extension MainCoordinator: SettingsCoordinatorDelegate {
    func settingsCoordinatorDidLogout(_ settingsCoordinator: SettingsCoordinator) {
        delegate?.mainCoordinatorDidLogout(self)
    }
}
