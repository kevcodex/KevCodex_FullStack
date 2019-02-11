//
//  AuthenticationWorker.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/11/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation
import MiniNe

final class AuthenticationWorker {
    
    enum Error: Swift.Error {
        case decodingError(_ error: Swift.Error)
        case requestError(_ error: MiniNeError)
    }
    
    static func login(with credentials: Credentials,
                      completion: @escaping (Result<User, Error>) -> Void) {
        
        let client = MiniNeClient()
        let request = AuthenticationNetworkRequest.loginRequest(email: credentials.username, password: credentials.password)
        
        client.send(request: request) { (result) in
            
            Thread.performOnMain {
                switch result {
                case .success(let response):
                    
                    do {
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: response.data)
                        
                        completion(Result(value: user))
                    } catch {
                        completion(Result(error: .decodingError(error)))
                    }
                    
                case .failure(let error):
                    completion(Result(error: .requestError(error)))
                }
            }
        }
    }
}
