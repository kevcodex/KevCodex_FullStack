//
//  Project.swift
//  App
//
//  Created by Kevin Chen on 1/30/19.
//

import Vapor
import MeowVapor

final class Project: Content, QueryableModel {
    var _id: ObjectId
    
    let title: String
    let imagePath: String
    let description: String
    let callToActionLink: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._id = try container.decodeIfPresent(ObjectId.self, forKey: ._id) ?? ObjectId()
        self.title = try container.decode(String.self, forKey: .title)
        self.imagePath = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.callToActionLink = try container.decode(String.self, forKey: .callToActionLink)
    }
    
    static var collectionName: String {
        return "projects"
    }
}
