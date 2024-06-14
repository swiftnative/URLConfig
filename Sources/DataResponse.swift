//
//  File.swift
//  
//
//  Created by Alexey Nenastev on 12.6.24..
//

import Foundation
import HTTPTypes

/// Response with data
public struct DataResponse {
  public let request: URLRequest
  public let status: HTTPResponse.Status
  public let headerFields: HTTPFields
  public let data: Data

  public init(request: URLRequest, response: HTTPResponse, data: Data) {
    self.request = request
    self.status = response.status
    self.headerFields = response.headerFields
    self.data = data
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
