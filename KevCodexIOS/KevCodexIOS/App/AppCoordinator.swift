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
    var rootViewController: UIViewController
    
    var childCoordinators: [String: Any] = [:]
    
    init?(window: UIWindow?) {
        
        guard let window = window else {
            return nil
        }
        
        self.window = window
        rootViewController = UIViewController()
        window.rootViewController = rootViewController
        
        super.init()
    }
    
    func start() {
        
        if let user = User.retrieve(),
            user.isValidAccessToken() {
            
            let mainCoordinator = MainCoordinator(user: user)
            
            rootViewController.addChildVC(mainCoordinator.rootViewController)
            
            addChild(coordinator: mainCoordinator)
            
        } else {
            let viewController = LoginViewController.makeFromStoryboard()
            viewController.delegate = self
            
            rootViewController.addChildVC(viewController)
        }
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func loginViewController(_ loginViewController: LoginViewController, didLogin user: User) {
        
        let mainCoordinator = MainCoordinator(user: user)
        
        addChild(coordinator: mainCoordinator)
        
        User.store(user: user)
        
        rootViewController.present(mainCoordinator.rootViewController, animated: true)
    }
}
