//
//  ProjectViewModel.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/17/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import UIKit

final class ProjectViewModel {
    private let imageCache = NSCache<NSString, UIImage>()
    private(set) var projects: [Project]
    
    init(projects: [Project] = []) {
        self.projects = projects
    }
    
    func project(at index: Int) -> Project? {
        guard projects.indices.contains(index) else {
            return nil
        }
        
        return projects[index]
    }
    
    func fetchProjects(completion: @escaping (Result<Void, ProjectWorker.Error>) -> Void) {
        ProjectWorker.getAllProjects { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let projects):
                strongSelf.projects = projects
                completion(.success)
            case .failure(let error):
                completion(Result(error: error))
            }
        }
    }
    
    func fetchImage(for project: Project, completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
        
        guard let imagePath = project.imageURLString.nonEmpty else {
            completion(Result(value: #imageLiteral(resourceName: "PlaceHolder")))
            return
        }
        
        if let cachedImage = self.imageCache.object(forKey: imagePath as NSString) {
            completion(Result(value: cachedImage))
        } else {
            ProjectWorker.loadImage(from: imagePath) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let image):
                    strongSelf.imageCache.setObject(image, forKey: imagePath as NSString)
                    completion(Result(value: image))
                case .failure(let error):
                    completion(Result(error: error))
                }
            }
        }
    }
}
