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
    
    private var detailNavigationController: UINavigationController?
    
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
        let yOffset = rootViewController.navigationBar.frame.maxY
        
        let (nav, detailsViewController) = ProjectDetailsViewController.makeFromStoryboardWithNavigation()
        
        let transitioner = ProjectDetailTransitioner(cellFrame: cellFrame, yOffset: yOffset)
        self.detailTransitioner = transitioner
        
        nav.transitioningDelegate = transitioner
        detailsViewController.project = cell.project
        detailsViewController.image = cell.imageView.image
        detailsViewController.delegate = self
        
        rootViewController.present(nav, animated: true)
        
        self.detailNavigationController = nav
    }
}

extension ProjectCoordinator: ProjectDetailsViewControllerDelegate {
    func projectDetailsViewController(_ projectDetailsViewController: ProjectDetailsViewController, didPressEdit project: Project) {
        
        guard let navigationController = detailNavigationController else {
            return
        }
        
        let editVC = ProjectEditorViewController.makeFromStoryboard()
        editVC.project = project
        editVC.delegate = self
        
        navigationController.pushViewController(editVC, animated: true)
    }
}

extension ProjectCoordinator: ProjectEditorViewControllerDelegate {
    func projectEditorViewController(_ projectEditorViewController: ProjectEditorViewController, didSubmitFor project: Project, withBody body: Project.UpdateBody, completion: @escaping () -> Void) {
        
        guard let navigationController = detailNavigationController else {
            return
        }
        
        ProjectWorker.editProject(id: project._id, accessToken: user.accessToken, body: body) { (result) in
            switch result {
            case .success:
                navigationController.dismiss(animated: true) {
                    self.detailNavigationController = nil
                }
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
}
