//
//  ProjectCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectCoordinator: Coordinator {
    let rootViewController: ProjectListViewController
    
    let user: User
    
    var detailNavigationController: UINavigationController?
    
    init(user: User) {
        self.user = user
        rootViewController = ProjectListViewController.makeFromStoryboard()
        rootViewController.delegate = self
    }
}

extension ProjectCoordinator: ProjectListViewControllerDelegate {
    func projectListViewController(_ projectListViewController: ProjectListViewController, didSelectProject project: Project, image: UIImage?) {
        let (navigation, controller) = ProjectDetailsViewController.makeFromStoryboardWithNavigation()
        controller.delegate = self
        controller.project = project
        controller.image = image
        
        detailNavigationController = navigation
        
        rootViewController.present(navigation, animated: true)
    }
    
    private func refreshListViewController() {
        
        rootViewController.refresh()
    }
}

extension ProjectCoordinator: ProjectDetailsViewControllerDelegate {
    func projectDetailsViewControllerDidDismiss(_ projectDetailsViewController: ProjectDetailsViewController) {
        projectDetailsViewController.dismiss(animated: true) {
            self.detailNavigationController = nil
        }
    }
    
    func projectDetailsViewController(_ projectDetailsViewController: ProjectDetailsViewController, didPressEditFor project: Project) {
        
        guard let navigation = detailNavigationController else {
            return
        }
        
        let vc = ProjectEditorViewController.makeFromStoryboard()
        vc.delegate = self
        vc.project = project
        
        navigation.pushViewController(vc, animated: true)
        
    }
    
    func projectDetailsViewController(_ projectDetailsViewController: ProjectDetailsViewController, didPressDelete project: Project) {
        
        guard let navigationController = detailNavigationController else {
            return
        }
        
        projectDetailsViewController.showActivityIndicator(title: "Loading")
        
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
            
            projectDetailsViewController.hideActivityIndicator()
        }
    }
}

extension ProjectCoordinator: ProjectEditorViewControllerDelegate {
    func projectEditorViewController(_ projectEditorViewController: ProjectEditorViewController, didSubmitFor project: Project, withBody body: Project.UpdateBody) {
        
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
            
            projectEditorViewController.hideActivityIndicator()
        }
    }    
}
