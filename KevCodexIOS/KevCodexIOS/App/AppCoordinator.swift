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
    var rootViewController: UINavigationController?
    
    var childCoordinators: [String: Any] = [:]
    
    init?(window: UIWindow?) {
        
        guard let window = window else {
            return nil
        }
        
        self.window = window
    }
    
    func start() {
        // Launch initial vc
        let viewController = LoginViewController.makeFromStoryboard()
        viewController.delegate = self
        
        rootViewController = UINavigationController(rootViewController: viewController)
        rootViewController?.delegate = self
        window.rootViewController = rootViewController
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func loginViewController(_ loginViewController: LoginViewController, didLogin user: User) {
        
        guard let navigationController = rootViewController else {
            return
        }
        
        let detailController = ProjectCoordinator(with: navigationController, user: user)
        
        addChild(coordinator: detailController)
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Look into better way of removing child Coordinator
        if let _ = viewController as? LoginViewController {
            removeChild(with: ProjectCoordinator.identifier)
        }
    }
}
