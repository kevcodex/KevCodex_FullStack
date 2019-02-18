//
//  ProjectListViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

protocol ProjectListViewControllerDelegate: class {
    func projectListViewController(_ projectListViewController: ProjectListViewController, didSelectProject project: Project, image: UIImage?)
}

final class ProjectListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let projectViewModel = ProjectViewModel()
    
    weak var delegate: ProjectListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        projectViewModel.fetchProjects() { result in
            
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
            self.collectionView.reloadData()
        }
    }
    
}

extension ProjectListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectViewModel.projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFeedCell", for: indexPath) as? ProjectFeedCell else {
            assertionFailure("Invalid")
            return UICollectionViewCell()
        }
        
        guard let project = projectViewModel.project(at: indexPath.row) else {
            return cell
        }
        
        if let imagePath = project.imageURLString.nonEmpty {
            
            projectViewModel.fetchImage(for: imagePath) { (result) in
                switch result {
                case .success(let image):
                    cell.imageView.image = image
                    cell.titleLabel.isHidden = true
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "PlaceHolder")
            cell.titleLabel.text = project.title
        }
        
        return cell
    }
}

extension ProjectListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let project = projectViewModel.project(at: indexPath.row) else {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as? ProjectFeedCell
        let image = cell?.imageView.image
        
        delegate?.projectListViewController(self, didSelectProject: project, image: image)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = UIScreen.main.bounds.width / 2
        
        if let viewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            size = size - viewFlowLayout.sectionInset.left - viewFlowLayout.sectionInset.right
        }
        
        return CGSize(width: size, height: size)
    }
}

extension ProjectListViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
