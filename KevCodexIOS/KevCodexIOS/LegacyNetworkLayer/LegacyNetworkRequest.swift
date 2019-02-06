//
//  NetworkRequest.swift
//  SampleProject
//
//  Created by Kirby on 6/19/17.
//  Copyright © 2017 Kirby. All rights reserved.

import Foundation

enum LegacyHTTPMethod: String {
  // for this app only need a get request
  case get

  var name: String {
    return rawValue.uppercased()
  }
}

// handles the request to get data
protocol LegacyNetworkRequest {

  associatedtype Response: JSONDecodable

  var baseURL: URL? { get }
  var path: String { get }
  var method: LegacyHTTPMethod { get }
    var parameters: [String: Any]? { get }
}

extension LegacyNetworkRequest {

  var baseURL: URL? {

    return URL(string: "https://kevcodex.com")
  }

  func buildURLRequest() -> URLRequest? {
    
    guard let baseURL = baseURL else {
      return nil
    }
    
    let url = baseURL.appendingPathComponent(path)
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

    switch method {
    case .get:
      let dictionary = parameters
      let queryItems = dictionary?.map { key, value in
        return URLQueryItem(name: key, value: String(describing: value))
      }
      components?.queryItems = queryItems
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.url = components?.url
    urlRequest.httpMethod = method.name

    return urlRequest
  }

  func response(from data: Data, urlResponse: URLResponse) throws -> Response {

    let json = try JSONSerialization.jsonObject(with: data, options: [])

    return try Response(json: json)
  }
}
