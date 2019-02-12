//
//  ImageLoader.swift
//  SampleProject
//
//  Created by Kevin Chen on 1/1/18.
//  Copyright © 2018 Kirby. All rights reserved.
//

import Foundation
import UIKit
import MiniNe

/// Async load images
final class ImageLoader {
    
    static func loadImage(from imagePath: String, completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
                
        let client = MiniNeClient()
        
        let request = ProjectsNetworkRequest.getImageRequest(imagePath: imagePath)
        
        client.send(request: request) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    guard let image = UIImage(data: response.data) else {
                        completion(Result(error: .apiFailed(message: "Data was malformed")))
                        return
                    }
                    
                    completion(Result(value: image))
                    
                case .failure(let error):
                    completion(Result(error: .apiFailed(message: "Error with api: \(error)")))
                }
            }
        }
    }
}
