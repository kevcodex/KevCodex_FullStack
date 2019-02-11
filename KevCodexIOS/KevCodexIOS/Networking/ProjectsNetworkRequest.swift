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
}
