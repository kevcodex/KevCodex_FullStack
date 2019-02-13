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
    let yOffset: CGFloat
    
    private let customTransition = CustomTransitionController()
    private let customDismissTransition = CustomDismissController()
    
    init(cellFrame: CGRect, yOffset: CGFloat) {
        self.cellFrame = cellFrame
        self.yOffset = yOffset
    }
}

// MARK: - Transition Delegate
extension ProjectDetailTransitioner: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customTransition.originFrame = cellFrame
        customTransition.yOffset = yOffset
        return customTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customDismissTransition.originFrame = dismissed.view.frame
        return customDismissTransition
    }
}
