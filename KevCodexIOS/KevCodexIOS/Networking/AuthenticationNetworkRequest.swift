//
//  AuthenticationNetworkRequest.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/11/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation
import MiniNe

struct AuthenticationNetworkRequest: NetworkRequest {
    
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

extension AuthenticationNetworkRequest {
    static func loginRequest(email: String, password: String) -> AuthenticationNetworkRequest {
        
        let parameters: [String: Any] = ["email": email,
                                      "password": password]
        
        let body = NetworkBody(parameters: parameters, encoding: .json)
        
        return AuthenticationNetworkRequest(path: "api/profile/login", method: .post, parameters: nil, headers: nil, body: body)
    }
}
