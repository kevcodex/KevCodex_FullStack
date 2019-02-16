//
//  HikingWorker.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/15/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import MiniNe

class HikingWorker {
    
    enum Error: Swift.Error {
        case decodingError(_ error: Swift.Error)
        case requestError(_ error: MiniNeError)
    }
    
    static func getAllHikes(completion: @escaping (Result<[Hike], Error>) -> Void) {
        let client = MiniNeClient()
        
        let request = HikingNetworkRequest.getAllHikesRequest()
        client.send(request: request) { result in
            
            Thread.performOnMainSync {
                switch result {
                case let .success(response):
                    
                    do {
                        let hikes = try JSONDecoder().decode([Hike].self, from: response.data)
                        completion(Result(value: hikes))
                    } catch {
                        completion(Result(error: .decodingError(error)))
                    }
                    
                case let .failure(error):
                    
                    completion(Result(error: .requestError(error)))
                }
            }
        }
    }
    
    static func loadImage(from imagePath: String, completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
        
        let request = HikingNetworkRequest.getImageRequest(imagePath: imagePath)
        
        ImageLoader.loadImage(from: request, completion: completion)
    }
    
    static func editHike(id: String, accessToken: String, body: Hike.UpdateBody, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let request = HikingNetworkRequest.editHikeRequest(id: id, accessToken: accessToken, body: body)
        
        let client = MiniNeClient()
        
        client.send(request: request) { result in
            
            Thread.performOnMainSync {
                switch result {
                case .success:
                    
                    completion(.success)
                    
                case let .failure(error):
                    
                    completion(Result(error: .requestError(error)))
                }
            }
        }
    }
    
    static func deleteHike(id: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let request = HikingNetworkRequest.deleteHikeRequest(id: id, accessToken: accessToken)
        
        let client = MiniNeClient()
        
        client.send(request: request) { result in
            
            Thread.performOnMainSync {
                switch result {
                case .success:
                    
                    completion(.success)
                    
                case let .failure(error):
                    
                    completion(Result(error: .requestError(error)))
                }
            }
        }
    }
}
