//
//  ProjectDetailsViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/17/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol ProjectDetailsViewControllerDelegate: class {
    func projectDetailsViewControllerDidDismiss(_ projectDetailsViewController: ProjectDetailsViewController)
    func projectDetailsViewController(_ projectDetailsViewController: ProjectDetailsViewController, didPressEditFor project: Project)
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
        
        let button = UIBarButtonItem(image: IconFactory.imageOfCrossIcon(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didPressCloseButton))
        
        navigationItem.setLeftBarButtonItems([button], animated: true)
    }
}

extension ProjectDetailsViewController {
    
    @objc func didPressCloseButton() {
        delegate?.projectDetailsViewControllerDidDismiss(self)
    }
    
    @IBAction func didPressEditButton(_ sender: UIButton) {
        
        guard let project = project else {
            return
        }
        
        delegate?.projectDetailsViewController(self, didPressEditFor: project)
    }
}

extension ProjectDetailsViewController: StoryboardNavigationInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
