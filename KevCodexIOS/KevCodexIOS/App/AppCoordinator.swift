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
        let projectListVC = ProjectListViewController.makeFromStoryboard()
        projectListVC.delegate = self
        navigationController?.pushViewController(projectListVC, animated: true)
    }
}

extension AppCoordinator: ProjectListViewControllerDelegate {
    func projectListViewController(_ projectListViewController: ProjectListViewController, didSelectItemAt indexPath: IndexPath, in collectionView: UICollectionView) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProjectFeedCell,
            let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) else {
                return
        }
        
        projectListViewController.cellFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        
        let detailsViewController = ProjectDetailsViewController.makeFromStoryboard()
        detailsViewController.transitioningDelegate = projectListViewController
        detailsViewController.result = cell.project
        
        detailsViewController.image = cell.imageView.image
        navigationController?.present(detailsViewController, animated: true)
    }
}
