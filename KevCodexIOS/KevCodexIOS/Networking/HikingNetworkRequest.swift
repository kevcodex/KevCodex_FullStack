//
//  HikingNetworkRequest.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import MiniNe

struct HikingNetworkRequest: NetworkRequest {
    
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

extension HikingNetworkRequest {
    static func getAllHikesRequest() -> HikingNetworkRequest {
        return HikingNetworkRequest(path: "api/hikes", method: .get, parameters: nil, headers: nil, body: nil)
    }
    
    static func getImageRequest(imagePath: String) -> HikingNetworkRequest {
        return HikingNetworkRequest(path: imagePath, method: .get, parameters: nil, headers: nil, body: nil)
    }
    
    static func editHikeRequest(id: String, accessToken: String, body: Hike.UpdateBody) -> HikingNetworkRequest {
        
        let headers: [String: Any] = ["Authorization": "Bearer \(accessToken)", "apiKey": App.apiKey]
        
        var body: NetworkBody? {
            guard let data = try? JSONEncoder().encode(body) else {
                    return nil
            }
            
            return NetworkBody(data: data, encoding: .json)
        }
        
        return HikingNetworkRequest(path: "api/hikes/\(id)", method: .put, parameters: nil, headers: headers, body: body)
    }
    
    static func addHikeRequest(accessToken: String, hike: Hike) -> HikingNetworkRequest {
        
        let headers: [String: Any] = ["Authorization": "Bearer \(accessToken)", "apiKey": App.apiKey]
        
        var body: NetworkBody? {
            guard let data = try? JSONEncoder().encode(hike) else {
                    return nil
            }
            
            return NetworkBody(data: data, encoding: .json)
        }
        
        return HikingNetworkRequest(path: "api/hikes", method: .post, parameters: nil, headers: headers, body: body)
    }
    
    static func deleteHikeRequest(id: String, accessToken: String) -> HikingNetworkRequest {
        
        let headers: [String: Any] = ["Authorization": "Bearer \(accessToken)", "apiKey": App.apiKey]
        
        return HikingNetworkRequest(path: "api/hikes/\(id)", method: .delete, parameters: nil, headers: headers, body: nil)
    }
}
