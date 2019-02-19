//
//  UIViewController+Extensions.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/13/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

extension UIViewController {

    func addChildVC(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func removeFromParentVC() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
