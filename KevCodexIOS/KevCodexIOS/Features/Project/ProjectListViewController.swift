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
    
}

extension ProjectListViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Project"
    }
}
