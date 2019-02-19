//
//  HikingFeedCell.swift
//  SampleProject
//
//  Created by Kirby on 6/20/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import UIKit

//the cell information
class HikingFeedCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var hike: Hike?
    
    func updateCell(with hike: Hike) {
        
        self.hike = hike
        
        descriptionLabel.text = hike.shortDescription
        titleLabel.text = hike.title
    }
}
