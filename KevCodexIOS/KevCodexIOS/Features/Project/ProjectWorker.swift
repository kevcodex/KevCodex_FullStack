//
//  ProjectWorker.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/11/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation
import MiniNe

class ProjectWorker {
    
    enum Error: Swift.Error {
        case decodingError(_ error: Swift.Error)
        case requestError(_ error: MiniNeError)
    }

    static func getAllProjects(completion: @escaping (Result<[Project], Error>) -> Void) {
        let client = MiniNeClient()
        
        let request = ProjectsNetworkRequest.getAllProjectsRequest()
        client.send(request: request) { result in
            
            Thread.performOnMainSync {
                switch result {
                case let .success(response):
                    
                    do {
                        let projects = try JSONDecoder().decode([Project].self, from: response.data)
                        completion(Result(value: projects))
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
        
        let request = ProjectsNetworkRequest.getImageRequest(imagePath: imagePath)
        
        ImageLoader.loadImage(from: request, completion: completion)
    }
    
    static func editProject(id: String, accessToken: String, body: Project.UpdateBody, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let request = ProjectsNetworkRequest.editProjectRequest(id: id, accessToken: accessToken, body: body)
        
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
    
    static func deleteProject(id: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let request = ProjectsNetworkRequest.deleteProjectRequest(id: id, accessToken: accessToken)
        
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
