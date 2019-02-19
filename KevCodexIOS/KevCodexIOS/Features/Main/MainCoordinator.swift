//
//  MainCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/12/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit
import FontAwesome_swift

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
        let hikeImage = UIImage.fontAwesomeIcon(name: .hiking, style: .solid, textColor: .black, size: CGSize(width: 40, height: 40))
        hiking.rootViewController.tabBarItem = UITabBarItem(title: "Hikes", image: hikeImage, tag: 0)
        
        let project = ProjectCoordinator(user: user)
        let projectImage = UIImage.fontAwesomeIcon(name: .star, style: .solid, textColor: .black, size: CGSize(width: 40, height: 40))
        project.rootViewController.tabBarItem = UITabBarItem(title: "Projects", image: projectImage, tag: 1)
        
        
        let settings = SettingsCoordinator(user: user, delegate: self)
        settings.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        addChild(coordinator: hiking)
        addChild(coordinator: project)
        addChild(coordinator: settings)
        
        rootViewController.addChild(project.rootViewController)
        rootViewController.addChild(hiking.rootViewController)
        rootViewController.addChild(settings.rootViewController)
    }
}

extension MainCoordinator: SettingsCoordinatorDelegate {
    func settingsCoordinatorDidLogout(_ settingsCoordinator: SettingsCoordinator) {
        delegate?.mainCoordinatorDidLogout(self)
    }
}
