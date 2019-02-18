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
        
        rootViewController.present(navigation, animated: true)
    }
}

extension ProjectCoordinator: ProjectDetailsViewControllerDelegate {
    
}
