//
//  ProjectCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/9/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectCoordinator: Coordinator {
    
    var rootViewController: UINavigationController?
    var detailTransitioner: ProjectDetailTransitioner?
    
    private let user: User
    
    init(with navigationController: UINavigationController, user: User) {
        self.rootViewController = navigationController
        self.user = user
        
        // Launch initial vc
        let projectListVC = ProjectListViewController.makeFromStoryboard()
        projectListVC.delegate = self
        navigationController.pushViewController(projectListVC, animated: true)
    }
}

extension ProjectCoordinator: ProjectListViewControllerDelegate {
    func projectListViewController(_ projectListViewController: ProjectListViewController, didSelectItemAt indexPath: IndexPath, in collectionView: UICollectionView) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProjectFeedCell,
            let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) else {
                return
        }
        
        let cellFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        
        let detailsViewController = ProjectDetailsViewController.makeFromStoryboard()
        
        let transitioner = ProjectDetailTransitioner(cellFrame: cellFrame)
        self.detailTransitioner = transitioner
        
        detailsViewController.transitioningDelegate = transitioner
        detailsViewController.result = cell.project
        
        detailsViewController.image = cell.imageView.image
        rootViewController?.present(detailsViewController, animated: true)
    }
}
