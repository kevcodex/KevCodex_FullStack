//
//  ProjectEditorViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/13/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectEditorViewController: UIViewController {
    
    var project: Project?

}

extension ProjectEditorViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
