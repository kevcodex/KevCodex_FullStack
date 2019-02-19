//
//  Project.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/5/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

struct Project: Codable {
    let _id: String?
    
    let title: String
    let imageURLString: String
    let description: String
    let callToActionLink: String
    let sortOrder: Int?

}

extension Project {

    struct UpdateBody: Codable {
        
        let title: String?
        let imageURLString: String?
        let description: String?
        let callToActionLink: String?
        let sortOrder: Int?
        
        func mapToProject() -> Project? {
            
            guard let title = title,
                let imageURLString = imageURLString,
                let description = description,
                let callToActionLink = callToActionLink,
                let sortOrder = sortOrder else {
                return nil
            }
            
            return Project(_id: nil, title: title, imageURLString: imageURLString, description: description, callToActionLink: callToActionLink, sortOrder: sortOrder)
        }
    }
}
