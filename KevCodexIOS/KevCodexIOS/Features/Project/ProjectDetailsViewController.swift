//
//  ProjectDetailsViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/17/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol ProjectDetailsViewControllerDelegate: class {
    
}

final class ProjectDetailsViewController: UIViewController {

    weak var delegate: ProjectDetailsViewControllerDelegate?
    
    var project: Project?
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let project = project else {
            return
        }
        
        titleLabel.text = project.title
        descriptionLabel.text = project.description
        imageView.image = image
    }
}

extension ProjectDetailsViewController: StoryboardNavigationInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
