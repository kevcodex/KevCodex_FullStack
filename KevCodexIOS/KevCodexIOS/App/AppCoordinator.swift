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
        
        super.init()
        
        rootViewController.delegate = self
        window.rootViewController = rootViewController
    }
    
    func start() {
        // Launch initial vc
        let viewController = LoginViewController.makeFromStoryboard()
        viewController.delegate = self
        
        rootViewController.setViewControllers([viewController], animated: true)
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func loginViewController(_ loginViewController: LoginViewController, didLogin user: User) {
        
        let mainCoordinator = MainCoordinator(user: user)
        
        addChild(coordinator: mainCoordinator)
        
        rootViewController.present(mainCoordinator.rootViewController, animated: true)
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Look into better way of removing child Coordinator
        if viewController is LoginViewController {
            removeChild(with: ProjectCoordinator.identifier)
        }
    }
}
