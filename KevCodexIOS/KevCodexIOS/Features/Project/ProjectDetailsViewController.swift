//
//  ProjectDetailsViewController.swift
//  SampleProject
//
//  Created by Kirby on 6/20/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

// shows details of the feed
final class ProjectDetailsViewController: UIViewController {
    
    var project: Project?
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //    dateLabel.text = result.readableDate
        titleLabel.text = project?.title
        descriptionLabel.text = project?.description
        
        let colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        let locations: [CGFloat] = [0.0, 1.0]
        
        if let cachedImage = image,
            let gradientImage = cachedImage.createGradient(with: colors, at: locations) {
            
            imageView.image = gradientImage
        } else {
            imageView.image = #imageLiteral(resourceName: "PlaceHolder")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationBar.isHidden = false
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        // navigationBar.tintColor = UIColor.white
    }
}

// MARK: - Actions
extension ProjectDetailsViewController {
    @IBAction func ShareTapped(_ sender: UIBarButtonItem) {
        
        guard let project = project,
            let image = image else {
                return
        }
        
        let vc = UIActivityViewController(activityItems: [project.title, image], applicationActivities: [])
        present(vc, animated: true)
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension ProjectDetailsViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
