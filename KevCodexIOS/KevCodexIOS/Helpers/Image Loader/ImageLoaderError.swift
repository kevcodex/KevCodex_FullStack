//
//  ImageLoaderError.swift
//  SampleProject
//
//  Created by Kevin Chen on 1/1/18.
//  Copyright © 2018 Kirby. All rights reserved.
//

import Foundation

enum ImageLoaderError: Error, Equatable {
    case invalidURL
    case apiFailed(message: String)
}
