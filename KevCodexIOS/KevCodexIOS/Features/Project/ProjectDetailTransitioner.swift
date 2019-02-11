//
//  ProjectDetailTransitioner.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/9/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectDetailTransitioner: NSObject {
    let cellFrame: CGRect
    
    private let customTransition = CustomTransitionController()
    private let customDismissTransition = CustomDismissController()
    
    init(cellFrame: CGRect) {
        self.cellFrame = cellFrame
    }
}

// MARK: - Transition Delegate
extension ProjectDetailTransitioner: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customTransition.originFrame = cellFrame
        return customTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customDismissTransition.originFrame = dismissed.view.frame
        return customDismissTransition
    }
}
