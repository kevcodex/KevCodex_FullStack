//
//  StoryboardNavigationInitializable.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/12/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol StoryboardNavigationInitializable: StoryboardInitializable {
    
    static func makeFromStoryboardWithNavigation() -> (UINavigationController, Self)
}

extension StoryboardNavigationInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self) + "Navigation"
    }
    
    static func makeFromStoryboardWithNavigation() -> (UINavigationController, Self) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        
        guard let navigation = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? UINavigationController,
            let viewController = navigation.viewControllers.first as? Self else {
                
                fatalError("No navigation controller with identifier \(storyboardIdentifier) in storyboard")
        }
        
        return (navigation, viewController)
    }
}
