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
    
    var isEditingProject: Bool = false
    
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
    
    func projectListViewControllerDidPressAdd(_ projectListViewController: ProjectListViewController) {
        isEditingProject = false
        
        let vc = ProjectEditorViewController.makeFromStoryboard()
        vc.delegate = self
        
        rootViewController.present(vc, animated: true)
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
        
        isEditingProject = true
        
        let vc = ProjectEditorViewController.makeFromStoryboard()
        vc.delegate = self
        vc.project = project
        
        navigation.pushViewController(vc, animated: true)
    }
    
    func projectDetailsViewController(_ projectDetailsViewController: ProjectDetailsViewController, didPressDelete project: Project) {
        
        guard let navigationController = detailNavigationController,
            let id = project._id else {
            return
        }
        
        projectDetailsViewController.showActivityIndicator(title: "Loading")
        
        ProjectWorker.deleteProject(id: id, accessToken: user.accessToken) { [weak self] (result) in
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
    func shouldRemoveDismissButton() -> Bool {
        return isEditingProject ? true : false
    }
    
    func projectEditorViewController(_ projectEditorViewController: ProjectEditorViewController, didSubmitFor project: Project?, withBody body: Project.UpdateBody) {
        
        projectEditorViewController.showActivityIndicator(title: "Loading")
        
        if isEditingProject {
            
            guard let navigationController = detailNavigationController,
                let id = project?._id else {
                projectEditorViewController.hideActivityIndicator()
                return
            }
            
            ProjectWorker.editProject(id: id, accessToken: user.accessToken, body: body) { [weak self] (result) in
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
        } else {
            
            guard let project = body.mapToProject() else {
                print("Missing a field")
                projectEditorViewController.hideActivityIndicator()
                return
            }
            
            ProjectWorker.addProject(accessToken: user.accessToken, project: project) { [weak self] (result) in
                switch result {
                case .success:
                    projectEditorViewController.dismiss(animated: true) {
                        self?.refreshListViewController()
                    }
                case .failure(let error):
                    print(error)
                }
                
                projectEditorViewController.hideActivityIndicator()
            }
        }
    }
    
    func projectEditorViewControllerDidPressDismiss(_ projectEditorViewController: ProjectEditorViewController) {
        projectEditorViewController.dismiss(animated: true)
    }
}
