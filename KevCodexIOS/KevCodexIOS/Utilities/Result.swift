//
//  Result.swift
//  SampleProject
//
//  Created by Kirby on 6/19/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import Foundation

// A generic result for success or failure
enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
    
    init(value: T) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}

extension Result {
    func unbox() throws -> T {
        switch self {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}

extension Result where T == Void {
    init() {
        self = .success(())
    }
    
    static var success: Result {
        return .success(())
    }
}
