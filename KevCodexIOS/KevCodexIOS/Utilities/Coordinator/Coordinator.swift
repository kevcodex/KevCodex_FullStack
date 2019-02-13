//
//  Coordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/9/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    
    associatedtype RootViewController: UIViewController
    
    var rootViewController: RootViewController { get }
}

extension Coordinator {
    var identifier: String {
        
        guard let identifier = String(describing: self).components(separatedBy: ".").last else {
            assertionFailure("Something went wrong!")
            return ""
        }
        
        return identifier
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
