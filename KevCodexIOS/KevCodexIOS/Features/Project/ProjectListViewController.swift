//
//  ProjectListViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let projectViewModel = ProjectViewModel()
    
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
        
        projectViewModel.fetchImage(for: project) { (result) in
            switch result {
            case .success(let image):
                cell.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
        
        cell.update(with: project)
        
        return cell
    }
}

extension ProjectListViewController: UICollectionViewDelegate {
    
}

extension ProjectListViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
