//
//  ProjectCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/9/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectCoordinator: Coordinator {
    
    let rootViewController: UINavigationController
    
    private var detailTransitioner: ProjectDetailTransitioner?
    private let user: User
    
    init(user: User) {
        self.user = user
        
        // Launch initial vc
        let (nav, projectListVC) = ProjectListViewController.makeFromStoryboardWithNavigation()
        
        self.rootViewController = nav
        
        projectListVC.delegate = self
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
        detailsViewController.project = cell.project
        detailsViewController.image = cell.imageView.image
        
        rootViewController.present(detailsViewController, animated: true)
    }
}
