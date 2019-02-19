//
//  AppCoordinator.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/23/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import UIKit

final class AppCoordinator: NSObject, CoordinatorWithChildren {
    let window: UIWindow
    var rootViewController: UINavigationController
    
    var childCoordinators: [String: Any] = [:]
    
    init?(window: UIWindow?) {
        
        guard let window = window else {
            return nil
        }
        
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.isNavigationBarHidden = true
        window.rootViewController = rootViewController
        
        super.init()
    }
    
    func start() {
        
        if let user = User.retrieve(),
            user.isValidAccessToken() {
            
            let mainCoordinator = MainCoordinator(user: user, delegate: self)
            
            rootViewController.setViewControllers([mainCoordinator.rootViewController], animated: true)
            
            addChild(coordinator: mainCoordinator)
            
        } else {
            
            let loginViewController = LoginViewController.makeFromStoryboard()
            loginViewController.delegate = self

            rootViewController.setViewControllers([loginViewController], animated: true)
        }
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func loginViewController(_ loginViewController: LoginViewController, didLogin user: User) {
        
        let mainCoordinator = MainCoordinator(user: user, delegate: self)
        
        addChild(coordinator: mainCoordinator)
        
        User.store(user: user)
        
        rootViewController.setViewControllers([mainCoordinator.rootViewController], animated: true)
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidLogout(_ mainCoordinator: MainCoordinator) {
        User.removeCache()
        removeAllChildren()
        
        let loginViewController = LoginViewController.makeFromStoryboard()
        loginViewController.delegate = self
        
        rootViewController.setViewControllers([loginViewController, mainCoordinator.rootViewController], animated: false)
        
        rootViewController.popToRootViewController(animated: true)
    }
}
