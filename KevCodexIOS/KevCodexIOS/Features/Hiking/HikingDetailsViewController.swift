//
//  HikingDetailsViewController.swift
//  SampleProject
//
//  Created by Kirby on 6/20/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

protocol HikingDetailsViewControllerDelegate: class {
    func hikingDetailsViewController(_ hikingDetailsViewController: HikingDetailsViewController, didPressEdit project: Project)
    
    func hikingDetailsViewControllerDidPressBack(_ hikingDetailsViewController: HikingDetailsViewController)
    
    func hikingDetailsViewController(_ hikingDetailsViewController: HikingDetailsViewController, didConfirmDelete project: Project, completion: @escaping () -> Void)
}

// shows details of the feed
final class HikingDetailsViewController: UIViewController {
    
    var project: Project?
    var image: UIImage?
    
    var navigationBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    weak var delegate: HikingDetailsViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        
        navigationBar?.isHidden = false
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
        // navigationBar.tintColor = UIColor.white
    }
}

// MARK: - Actions
extension HikingDetailsViewController {
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        
        guard let project = project,
            let image = image else {
                return
        }
        
        let vc = UIActivityViewController(activityItems: [project.title, image], applicationActivities: [])
        present(vc, animated: true)
    }
    
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        
        delegate?.hikingDetailsViewControllerDidPressBack(self)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        guard let project = project else {
            return
        }
        
        delegate?.hikingDetailsViewController(self, didPressEdit: project)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        guard let project = project else {
            return
        }
        
        let controller = UIAlertController(title: "Permanently Delete?", message: "This action is irreversible, so make sure you are sure.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            
            self.showActivityIndicator(title: "Loading")
            self.delegate?.hikingDetailsViewController(self, didConfirmDelete: project) {
               self.hideActivityIndicator()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        controller.addAction(confirmAction)
        controller.addAction(cancelAction)
        
        present(controller, animated: true)
    }
}

extension HikingDetailsViewController: ActivityIndicatorPresenter {}

extension HikingDetailsViewController: StoryboardNavigationInitializable {
    static var storyboardName: String {
        return "Hiking"
    }
}
