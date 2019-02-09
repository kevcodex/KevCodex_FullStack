//
//  ProjectListViewController.swift
//  SampleProject
//
//  Created by Kirby on 6/19/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit
import MiniNe

protocol ProjectListViewControllerDelegate: class {
    func projectListViewController(_ projectListViewController: ProjectListViewController, didSelectItemAt indexPath: IndexPath, in collectionView: UICollectionView)
}

// Shows a collection view of the objects recieved
final class ProjectListViewController: UIViewController {
    
    let client = MiniNeClient()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var results: [Project] = []
    
    var activityIndicator = ActivityProgressHud()
    
    weak var delegate: ProjectListViewControllerDelegate?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(title: "Loading")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let request = ProjectsNetworkRequest.getAllProjectsRequest()
        client.send(request: request) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case let .success(response):
                
                do {
                    let projects = try JSONDecoder().decode([Project].self, from: response.data)
                    strongSelf.results = projects
                } catch {
                    print(error)
                }
                
                DispatchQueue.main.sync {
                    strongSelf.collectionView.reloadData()
                    strongSelf.hideActivityIndicator()
                }
                
            case let .failure(error):
                print(error)
                DispatchQueue.main.sync {
                    strongSelf.collectionView.reloadData()
                    strongSelf.hideActivityIndicator()
                }
            }
        }
    }
}

// MARK: - Collection View datasource
extension ProjectListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectFeedCell", for: indexPath) as! ProjectFeedCell
        
        let result = results[indexPath.row]
        
        cell.updateCell(with: result)
        cell.imageView.image = #imageLiteral(resourceName: "PlaceHolder")
        
//        if let imagePath = result.imagePath {
//
//            if let cachedImage = self.imageCache.object(forKey: imagePath as NSString) {
//                self.fadeImageView(cell.imageView, to: cachedImage, with: 0.5)
//            } else {
//                ImageLoader.loadImage(from: imagePath) { (image, error) in
//                    guard let image = image, error == .noError else {
//                        cell.imageView.image = #imageLiteral(resourceName: "PlaceHolder")
//                        return
//                    }
//
//                    self.imageCache.setObject(image, forKey: imagePath as NSString)
//                    self.fadeImageView(cell.imageView, to: image, with: 0.5)
//                }
//            }
//        } else {
        cell.imageView.image = #imageLiteral(resourceName: "PlaceHolder")
//        }
        
        return cell
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.projectListViewController(self, didSelectItemAt: indexPath, in: collectionView)
    }
}

// MARK: - Collection View Delegate

extension ProjectListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        
        var baseCellWidth: CGFloat = 375.0
        
        // for screens twice as large than the intrinsic base cell, have two cells per row
        // otherwise stretch to width of screensize
        if screenWidth > baseCellWidth * 2 {
            baseCellWidth = screenWidth / 2
        } else {
            baseCellWidth = screenWidth
        }
        
        return CGSize(width: baseCellWidth, height: 200)
    }
}

// MARK: - Transition View
extension ProjectListViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Private Helpers
fileprivate extension ProjectListViewController {
    func fadeImageView(_ imageView: UIImageView, to newImage: UIImage, with duration: TimeInterval) {
        UIView.transition(with: imageView,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
                            imageView.image = newImage
        },
                          completion: nil)
    }
}

// MARK: - Activity Presentor Protocol
extension ProjectListViewController: ActivityIndicatorPresentor {
}

extension ProjectListViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}




// MARK: - Segue

//extension ProjectListViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let cell = sender as? ProjectFeedCell,
//            let indexPath = collectionView.indexPath(for: cell),
//            let detailsViewController = segue.destination as? ProjectDetailsViewController
//
//            else {
//                return
//        }
//
//        guard let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) else {
//            return
//        }
//
//        cellFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
//
//        detailsViewController.transitioningDelegate = self
//        detailsViewController.result = cell.project
//
//        detailsViewController.image = cell.imageView.image
//    }
//}
