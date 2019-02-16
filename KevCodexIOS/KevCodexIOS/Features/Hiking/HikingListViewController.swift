//
//  HikingListViewController.swift
//  SampleProject
//
//  Created by Kirby on 6/19/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

protocol HikingListViewControllerDelegate: class {
    func hikingListViewController(_ hikingListViewController: HikingListViewController, didSelectItemAt indexPath: IndexPath, in collectionView: UICollectionView)
}

// Shows a collection view of the objects recieved
final class HikingListViewController: UIViewController {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var hikes: [Hike] = []
    
    var activityIndicator = ActivityProgressHud()
    
    weak var delegate: HikingListViewControllerDelegate?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        refresh()
    }
    
    func refresh() {
        showActivityIndicator(title: "Loading")
        
        HikingWorker.getAllHikes { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let hikes):
                strongSelf.hikes = hikes
            case .failure(let error):
                print(error)
            }
            
            strongSelf.collectionView.reloadData()
            strongSelf.hideActivityIndicator()
        }
    }
}

// MARK: - Collection View datasource
extension HikingListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hikes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HikingFeedCell", for: indexPath) as! HikingFeedCell
        
        let hike = hikes[indexPath.row]
        
        cell.updateCell(with: hike)
        cell.imageView.image = #imageLiteral(resourceName: "PlaceHolder")
        
        // Make image url optional in server
        guard let imagePath = hike.imageURLString?.nonEmpty else {
            cell.imageView.image = #imageLiteral(resourceName: "PlaceHolder")
            return cell
        }
        
        if let cachedImage = self.imageCache.object(forKey: imagePath as NSString) {
            self.fadeImageView(cell.imageView, to: cachedImage, with: 0.5)
        } else {
            HikingWorker.loadImage(from: imagePath) { [weak self] result in
                
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let image):
                    strongSelf.imageCache.setObject(image, forKey: imagePath as NSString)
                    strongSelf.fadeImageView(cell.imageView, to: image, with: 0.5)
                case .failure(let error):
                    print(error)
                    cell.imageView.image = #imageLiteral(resourceName: "PlaceHolder")
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.hikingListViewController(self, didSelectItemAt: indexPath, in: collectionView)
    }
}

// MARK: - Collection View Delegate

extension HikingListViewController: UICollectionViewDelegateFlowLayout {
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
extension HikingListViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Private Helpers
private extension HikingListViewController {
    func fadeImageView(_ imageView: UIImageView, to newImage: UIImage, with duration: TimeInterval) {
        UIView.transition(with: imageView,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: {
                            imageView.image = newImage
        })
    }
}

// MARK: - Activity Presentor Protocol
extension HikingListViewController: ActivityIndicatorPresenter {
}

extension HikingListViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Hiking"
    }
}




// MARK: - Segue

//extension HikingListViewController {
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
