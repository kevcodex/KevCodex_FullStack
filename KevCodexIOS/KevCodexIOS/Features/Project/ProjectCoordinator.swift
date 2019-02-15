//
//  ProjectCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/9/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectCoordinator: Coordinator {
    
    let rootViewController: ProjectListViewController
    
    private var detailTransitioner: ProjectDetailTransitioner?
    private let user: User
    
    private var detailNavigationController: UINavigationController?
    
    init(user: User) {
        self.user = user
        
        // Launch initial vc
        let projectListVC = ProjectListViewController.makeFromStoryboard()
        
        self.rootViewController = projectListVC
        
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
        
        let (nav, detailsViewController) = ProjectDetailsViewController.makeFromStoryboardWithNavigation()
        
        let yOffset = nav.navigationBar.frame.maxY
        
        let transitioner = ProjectDetailTransitioner(cellFrame: cellFrame, yOffset: yOffset)
        self.detailTransitioner = transitioner
        
        nav.transitioningDelegate = transitioner
        detailsViewController.project = cell.project
        detailsViewController.image = cell.imageView.image
        detailsViewController.delegate = self
        
        rootViewController.present(nav, animated: true)
        
        self.detailNavigationController = nav
    }
    
    private func refreshListViewController() {
        
        rootViewController.refresh()
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
    
    func projectDetailsViewControllerDidPressBack(_ projectDetailsViewController: ProjectDetailsViewController) {
        guard let navigationController = detailNavigationController else {
            return
        }
        
        navigationController.dismiss(animated: true)
    }
    
    func projectDetailsViewController(_ projectDetailsViewController: ProjectDetailsViewController, didConfirmDelete project: Project, completion: @escaping () -> Void) {
        
        guard let navigationController = detailNavigationController else {
            return
        }
        
        ProjectWorker.deleteProject(id: project._id, accessToken: user.accessToken) { [weak self] (result) in
            switch result {
            case .success:
                navigationController.dismiss(animated: true) {
                    self?.detailNavigationController = nil
                    self?.refreshListViewController()
                }
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
}

extension ProjectCoordinator: ProjectEditorViewControllerDelegate {
    func projectEditorViewController(_ projectEditorViewController: ProjectEditorViewController, didSubmitFor project: Project, withBody body: Project.UpdateBody, completion: @escaping () -> Void) {
        
        guard let navigationController = detailNavigationController else {
            return
        }
        
        ProjectWorker.editProject(id: project._id, accessToken: user.accessToken, body: body) { [weak self] (result) in
            switch result {
            case .success:
                navigationController.dismiss(animated: true) {
                    self?.detailNavigationController = nil
                    self?.refreshListViewController()
                }
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
}
