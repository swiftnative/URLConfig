//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.


import Foundation
import HTTPTypes

/// Response with data
public struct DataResponse {
  /// URLRequest
  public let request: URLRequest
  /// HTTP Status of response
  public let status: HTTPResponse.Status
  /// Response headers
  public let headerFields: HTTPFields
  /// Response data
  public let data: Data
  /// Response was obtained from cache
  public let fromCache: Bool
  /// Requast - Response duration ( sec )
  public let duration: TimeInterval

  public init(request: URLRequest, response: HTTPResponse, data: Data, fromCache: Bool = false, duration: TimeInterval) {
    self.request = request
    self.status = response.status
    self.headerFields = response.headerFields
    self.data = data
    self.fromCache = fromCache
    self.duration = duration
  }

  public struct Config {
    public var decoder: JSONDecoder = defaultDecoder
    public static var defaultDecoder = JSONDecoder()

    public init () {}
  }

  public func decode<T: Decodable>(
    _ config: Config = .init(),
    _ type: T.Type = T.self) throws -> T {
      try config.decoder.decode(type, from: data)
  }

  public func decode<T: Decodable>(
    decoder: JSONDecoder,
    _ type: T.Type = T.self
  ) throws -> T {
    try decoder.decode(type, from: data)
  }

  public var bodyString: String { data.json ?? "" }
}

extension DataResponse: Error {

}
