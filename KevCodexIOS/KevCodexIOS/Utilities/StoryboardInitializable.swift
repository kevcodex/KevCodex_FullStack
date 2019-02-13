//
//  StoryboardInitializable.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/8/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

import UIKit

protocol StoryboardInitializable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle? { get }
    static var storyboardIdentifier: String { get }
    static func makeFromStoryboard() -> Self
}

extension StoryboardInitializable {
    
    static var storyboardBundle: Bundle? {
        return nil
    }
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func makeFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No view controller with identifier \(storyboardIdentifier) in storyboard")
        }
        
        return viewController
    }
}

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
