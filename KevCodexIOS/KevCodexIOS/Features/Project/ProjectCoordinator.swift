//
//  ProjectCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

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
    func projectListViewController(_ projectListViewController: ProjectListViewController, didSelectProject project: Project) {
        
    }
}
