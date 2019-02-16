//
//  HikingCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

final class HikingCoordinator: Coordinator {
    let rootViewController: HikingListViewController
    
    let user: User
    
    init(user: User) {
        self.user = user
        rootViewController = HikingListViewController.makeFromStoryboard()
    }
}
