//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.


import Foundation

extension URLRequest {

  enum Method: String {
    case get
    case post
  }

  struct Config {
    public var host: String = "https://dogapi.dog"
    public var path: String = ""
    public var urlParams: [String: String] = [:]
    public var bodyParams: [String: Any] = [:]
    public var method: Method = .get
    public var headers: [String: String] = [:]
  }

  static func with(
    _ config: Config = .init(),
    _ configurate: (inout Config) -> Void
  ) -> URLRequest {
    var config = config
    configurate(&config)
    return with(config: config)
  }

  /// Build URLRequest with config
  private static func with(config: Config) -> URLRequest {

    guard var components = URLComponents(string: config.host + config.path) else {
      fatalError("You provide incorrect URL components host+path: \(config.host)\(config.path)")
    }

    if !config.urlParams.isEmpty {
      components.queryItems = config.urlParams.map { URLQueryItem(name: $0.key, value: $0.value) }
    }

    guard let url = components.url else {
      fatalError("You provide incorrect URL components host:\(config.host) path: \(config.path)")
    }

    var request = URLRequest(url: url)
    request.httpMethod = config.method.rawValue
    request.allHTTPHeaderFields = config.headers

    return request
  }

}
