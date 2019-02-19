//
//  App.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/23/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import Foundation

enum App {
    static let APIBaseURL: String? = {
        guard let baseURL = Bundle.main.infoDictionary?["API_ENDPOINT"] as? String else {
            assertionFailure("API_ENDPOINT is missing from the Info.plist file")
            return nil
        }
        
        return baseURL
    }()
    
    static var apiKey: String {
        #if DEBUG
            return "27a9bec8-aa92-4a3f-800f-7618637d14a6"
        #else
            return "7b3db366-6310-418a-8069-edb6c164ef41"
        #endif
    }
}
