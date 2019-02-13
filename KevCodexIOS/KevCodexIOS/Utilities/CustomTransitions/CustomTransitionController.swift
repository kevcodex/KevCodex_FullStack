//
//  CustomTransitionController.swift
//  SampleProject
//
//  Created by Kirby on 6/20/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

// for animating the "slide" effect
class CustomTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame = CGRect.zero
    
    var yOffset: CGFloat = 0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        if let navController = fromVC.navigationController {
            yOffset = navController.navigationBar.frame.height
        }
        
        let containerView = transitionContext.containerView
        let snapshotRect = CGRect(origin: CGPoint(x: 0, y: yOffset), size: toVC.view.frame.size)
        
        guard let snapshot = toVC.view.resizableSnapshotView(from: snapshotRect, afterScreenUpdates: true, withCapInsets: .zero) else {
            return
        }
        
        snapshot.frame.origin = originFrame.origin
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: { 
            
            fromVC.view.alpha = 0.0
            
        }, completion: { _ in
            
            UIView.animate(withDuration: duration, animations: {
                var frame = toVC.view.frame
                frame = frame.offsetBy(dx: 0, dy: self.yOffset)

                snapshot.frame = frame
                
            }, completion: { _ in
                
                toVC.view.isHidden = false
                toVC.view.alpha = 1.0
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            })
        })
    }
}
