//
//  SettingsCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorDelegate: class {
    func settingsCoordinatorDidLogout(_ settingsCoordinator: SettingsCoordinator)
}

final class SettingsCoordinator: Coordinator {
    
    let user: User
    
    let rootViewController: SettingsViewController
    
    weak var delegate: SettingsCoordinatorDelegate?
    
    init(user: User, delegate: SettingsCoordinatorDelegate) {
        self.user = user
        self.delegate = delegate
        
        let settingsVC = SettingsViewController.makeFromStoryboard()
        
        rootViewController = settingsVC
        
        settingsVC.delegate = self
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func settingsViewControllerDidPressLogout(_ settingsViewController: SettingsViewController) {
        // TODO: - Need server to have an endpoint to logout 
        delegate?.settingsCoordinatorDidLogout(self)
    }
}
