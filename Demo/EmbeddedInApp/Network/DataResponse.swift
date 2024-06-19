//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.


import Foundation

/// Response with data
public struct DataResponse {
  let request: URLRequest
  let response: HTTPURLResponse
  let data: Data
  let status: URLResponse.Status
  let fields: [String: String]

  func decode<T: Decodable>(decoder: JSONDecoder = JSONDecoder(),
                            _ type: T.Type = T.self) throws -> T {
    try decoder.decode(type, from: data)
  }
}
