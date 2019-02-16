//
//  SettingsCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    
    let user: User
    
    let rootViewController: SettingsViewController
    
    init(user: User) {
        self.user = user
        rootViewController = SettingsViewController.makeFromStoryboard()
    }
}
