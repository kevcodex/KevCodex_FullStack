//
//  ProjectsNetworkRequest.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/5/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation
import MiniNe

struct ProjectsNetworkRequest: NetworkRequest {
    
    var baseURL: URL? {
        guard let baseURLString = App.APIBaseURL else {
            return nil
        }
        
        return URL(string: baseURLString)
    }
    
    var path: String
    
    var method: HTTPMethod
    
    var parameters: [String: Any]?
    
    var headers: [String: Any]?
    
    var body: NetworkBody?
}

extension ProjectsNetworkRequest {
    static func getAllProjectsRequest() -> ProjectsNetworkRequest {
        return ProjectsNetworkRequest(path: "api/projects", method: .get, parameters: nil, headers: nil, body: nil)
    }
    
    static func getImageRequest(imagePath: String) -> ProjectsNetworkRequest {
        return ProjectsNetworkRequest(path: imagePath, method: .get, parameters: nil, headers: nil, body: nil)
    }
    
    static func addProjectRequest(accessToken: String, project: Project) -> ProjectsNetworkRequest {
        
        let headers: [String: Any] = ["Authorization": "Bearer \(accessToken)", "apiKey": App.apiKey]
        
        var body: NetworkBody? {
            guard let data = try? JSONEncoder().encode(project) else {
                    return nil
            }
            
            return NetworkBody(data: data, encoding: .json)
        }
        
        return ProjectsNetworkRequest(path: "api/projects", method: .post, parameters: nil, headers: headers, body: body)
    }
    
    static func editProjectRequest(id: String, accessToken: String, body: Project.UpdateBody) -> ProjectsNetworkRequest {
        
        let headers: [String: Any] = ["Authorization": "Bearer \(accessToken)", "apiKey": App.apiKey]
        
        var body: NetworkBody? {
            guard let data = try? JSONEncoder().encode(body) else {
                return nil
            }
            
            return NetworkBody(data: data, encoding: .json)
        }
        
        return ProjectsNetworkRequest(path: "api/projects/\(id)", method: .put, parameters: nil, headers: headers, body: body)
    }
    
    static func deleteProjectRequest(id: String, accessToken: String) -> ProjectsNetworkRequest {
        
        let headers: [String: Any] = ["Authorization": "Bearer \(accessToken)", "apiKey": App.apiKey]
        
        return ProjectsNetworkRequest(path: "api/projects/\(id)", method: .delete, parameters: nil, headers: headers, body: nil)
    }
}
