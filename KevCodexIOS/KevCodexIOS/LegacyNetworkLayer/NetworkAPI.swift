//
//  NetworkAPI.swift
//  SampleProject
//
//  Created by Kirby on 6/19/17.
//  Copyright © 2017 Kirby. All rights reserved.
//

import Foundation

// implements endpoint(s)
final class NetworkAPI {
  struct Feed: LegacyNetworkRequest {

    typealias Response = NetworkSearchResponse<ObjectFeed>

    var path: String {
      return "/api/games"
    }

    var parameters: [String: Any]? {
        return nil
    }

    var method: LegacyHTTPMethod {
      return .get
    }
  }
}
