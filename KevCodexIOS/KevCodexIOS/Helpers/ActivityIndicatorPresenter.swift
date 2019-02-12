//
//  ActivityIndicatorPresenter.swift
//  SampleProject
//
//  Created by Kirby on 6/20/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

/// Used for view controllers that need to present an activity indicator
protocol ActivityIndicatorPresenter {
    
    func showActivityIndicator(title: String)
    
    func hideActivityIndicator()
}

extension ActivityIndicatorPresenter where Self: UIViewController {
    
    func showActivityIndicator(title: String) {
        
        let activityIndicator = ActivityProgressHud()
        
        // prevents another progress hud from appearing if it already exists
        if self.isActivityIndicatorPresent {
            return
        }
        
        activityIndicator.text = title
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 85, height: 85)
        activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
        view.addSubview(activityIndicator)
        
    }
    
    func hideActivityIndicator() {
        guard let activityIndicator = view.subviews.first(where: { $0 is ActivityProgressHud }) else {
            return
        }
        activityIndicator.removeFromSuperview()
    }
    
    /// Checks to see if a activity indicator is already presented in the view
    private var isActivityIndicatorPresent: Bool {
        
        return view.subviews.contains { $0 is ActivityProgressHud }
    }
}
