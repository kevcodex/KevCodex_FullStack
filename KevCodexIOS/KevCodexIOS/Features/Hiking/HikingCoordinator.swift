//
//  HikingCoordinator.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/9/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class HikingCoordinator: Coordinator {
    
    let rootViewController: HikingListViewController
    
    private var detailTransitioner: HikingDetailTransitioner?
    private let user: User
    
    private var detailNavigationController: UINavigationController?
    
    var isEditingHike: Bool = false
    
    init(user: User) {
        self.user = user
        
        // Launch initial vc
        let hikingListVC = HikingListViewController.makeFromStoryboard()
        
        self.rootViewController = hikingListVC
        
        hikingListVC.delegate = self
    }
}

extension HikingCoordinator: HikingListViewControllerDelegate {
    
    func hikingListViewController(_ hikingListViewController: HikingListViewController, didSelectItemAt indexPath: IndexPath, in collectionView: UICollectionView) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? HikingFeedCell,
            let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) else {
                return
        }
        
        let cellFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        
        let (nav, detailsViewController) = HikingDetailsViewController.makeFromStoryboardWithNavigation()
        
        let yOffset = nav.navigationBar.frame.maxY
        
        let transitioner = HikingDetailTransitioner(cellFrame: cellFrame, yOffset: yOffset)
        self.detailTransitioner = transitioner
        
        nav.transitioningDelegate = transitioner
        detailsViewController.hike = cell.hike
        detailsViewController.image = cell.imageView.image
        detailsViewController.delegate = self
        
        rootViewController.present(nav, animated: true)
        
        self.detailNavigationController = nav
    }
    
    func hikingListViewControllerDidPressAdd(_ hikingListViewController: HikingListViewController) {
        isEditingHike = false
        
        let vc = HikingEditorViewController.makeFromStoryboard()
        vc.delegate = self
        
        rootViewController.present(vc, animated: true)
    }
    
    private func refreshListViewController() {
        
        rootViewController.refresh()
    }
}

extension HikingCoordinator: HikingDetailsViewControllerDelegate {
    
    func hikingDetailsViewController(_ hikingDetailsViewController: HikingDetailsViewController, didPressEdit hike: Hike) {
        
        guard let navigationController = detailNavigationController else {
            return
        }
        
        isEditingHike = true
        
        let editVC = HikingEditorViewController.makeFromStoryboard()
        editVC.hike = hike
        editVC.delegate = self
        
        navigationController.pushViewController(editVC, animated: true)
    }
    
    func hikingDetailsViewControllerDidPressBack(_ hikingDetailsViewController: HikingDetailsViewController) {
        guard let navigationController = detailNavigationController else {
            return
        }
        
        navigationController.dismiss(animated: true)
    }
    
    func hikingDetailsViewController(_ hikingDetailsViewController: HikingDetailsViewController, didConfirmDelete hike: Hike, completion: @escaping () -> Void) {
        
        guard let navigationController = detailNavigationController,
            let id = hike._id else {
            return
        }
        
        HikingWorker.deleteHike(id: id, accessToken: user.accessToken) { [weak self] (result) in
            switch result {
            case .success:
                navigationController.dismiss(animated: true) {
                    self?.detailNavigationController = nil
                    self?.refreshListViewController()
                }
            case .failure(let error):
                print(error)
            }
            
            completion()
        }
    }
}

extension HikingCoordinator: HikingEditorViewControllerDelegate {
    func shouldRemoveDismissButton() -> Bool {
        return isEditingHike ? true : false
    }
    
    func hikingEditorViewController(_ hikingEditorViewController: HikingEditorViewController, didSubmitFor hike: Hike?, withBody body: Hike.UpdateBody) {
        
        if isEditingHike {
            
            guard let navigationController = detailNavigationController,
                let id = hike?._id else {
                hikingEditorViewController.hideActivityIndicator()
                return
            }
            
            hikingEditorViewController.showActivityIndicator(title: "Loading")
            
            HikingWorker.editHike(id: id, accessToken: user.accessToken, body: body) { [weak self] (result) in
                switch result {
                case .success:
                    navigationController.dismiss(animated: true) {
                        self?.detailNavigationController = nil
                        self?.refreshListViewController()
                    }
                case .failure(let error):
                    print(error)
                }
                
                hikingEditorViewController.hideActivityIndicator()
            }
        } else {
            guard let hike = body.mapToHike() else {
                print("Missing a field")
                hikingEditorViewController.hideActivityIndicator()
                return
            }
            
            HikingWorker.addHike(accessToken: user.accessToken, hike: hike) { [weak self] (result) in
                switch result {
                case .success:
                    hikingEditorViewController.dismiss(animated: true) {
                        self?.refreshListViewController()
                    }
                case .failure(let error):
                    print(error)
                }
                
                hikingEditorViewController.hideActivityIndicator()
            }
        }
    }
    
    func hikingEditorViewControllerDidPressDismiss(_ hikingEditorViewController: HikingEditorViewController) {
        hikingEditorViewController.dismiss(animated: true)
    }
}
