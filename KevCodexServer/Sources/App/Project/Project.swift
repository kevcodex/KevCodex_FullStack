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
    
    var title: String
    var imageURLString: String
    var description: String
    var callToActionLink: String
    var sortOrder: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._id = try container.decodeIfPresent(ObjectId.self, forKey: ._id) ?? ObjectId()
        self.title = try container.decode(String.self, forKey: .title)
        self.imageURLString = try container.decode(String.self, forKey: .imageURLString)
        self.description = try container.decode(String.self, forKey: .description)
        self.callToActionLink = try container.decode(String.self, forKey: .callToActionLink)
        self.sortOrder = try container.decodeIfPresent(Int.self, forKey: .sortOrder)
    }
    
    static var collectionName: String {
        return "projects"
    }
}

extension Project: MongoModelUpdateable {
    func updateFields(with body: UpdateBody) {
        if let title = body.title {
            self.title = title
        }
        
        if let imageURLString = body.imageURLString {
            self.imageURLString = imageURLString
        }
        
        if let description = body.description {
            self.description = description
        }
        
        if let callToActionLink = body.callToActionLink {
            self.callToActionLink = callToActionLink
        }
        
        if let sortOrder = body.sortOrder {
            self.sortOrder = sortOrder
        }
    }
}

extension Project {
    /// The body to update the project. Contains all optional params to allow one or all project info to be updatable
    struct UpdateBody: Content {
        
        let title: String?
        let imageURLString: String?
        let description: String?
        let callToActionLink: String?
        let sortOrder: Int?
    }
}
