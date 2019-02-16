//
//  HikingListViewController.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class HikingListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
}

extension HikingListViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Hiking"
    }
}
