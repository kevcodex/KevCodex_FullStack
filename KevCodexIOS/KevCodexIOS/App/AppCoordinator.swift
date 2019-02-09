//
//  AppCoordinator.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/23/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    var navigationController: UINavigationController?
    
    var detailController: ProjectCoordinator?
    
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
        
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func loginViewController(_ loginViewController: LoginViewController, didLogin username: String) {
        
        guard let navigationController = navigationController else {
            return
        }
        
        detailController = ProjectCoordinator(with: navigationController)
    }
}
