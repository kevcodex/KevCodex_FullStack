//
//  SettingsViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerDidPressLogout(_ settingsViewController: SettingsViewController)
}

final class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    @IBAction func didPressLogoutButton(_ sender: UIButton) {
        delegate?.settingsViewControllerDidPressLogout(self)
    }
}

extension SettingsViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Settings"
    }
}
