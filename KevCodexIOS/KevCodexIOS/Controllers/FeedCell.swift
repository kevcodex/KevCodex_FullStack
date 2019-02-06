//
//  FeedCell.swift
//  SampleProject
//
//  Created by Kirby on 6/20/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

//the cell information
class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var project: Project?
    
    func updateCell(with project: Project) {
        
        self.project = project
        
        descriptionLabel.text = project.description
        titleLabel.text = project.title
    }
    
}
