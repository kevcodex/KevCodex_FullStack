//
//  CoordinatorWithChildren.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/9/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

protocol CoordinatorWithChildren: Coordinator {
    // May want to look into not using associated type to avoid accidental non-coordinator entries
    var childCoordinators: [String: Any] { get set }
}

extension CoordinatorWithChildren {
    func addChild<T>(coordinator: T, setup: (() -> Void)? = nil) where T: Coordinator {
        childCoordinators[coordinator.identifier] = coordinator
        setup?()
    }
    
    func removeChild(with identifier: String, tearDown: (() -> Void)? = nil) {
        tearDown?()
        childCoordinators.removeValue(forKey: identifier)
    }
    
    func removeChild<T>(with type: T.Type, tearDown: (() -> Void)? = nil) where T: Coordinator {
        let identifier = type.identifier
        removeChild(with: identifier, tearDown: tearDown)
    }
    
    func removeAllChildren(tearDown: (() -> Void)? = nil) {
        tearDown?()
        childCoordinators.removeAll()
    }
}
