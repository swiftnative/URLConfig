//
//  DataResponse.swift
//  EmbeddedInApp
//
//  Created by Alexey Nenastev on 14.6.24..
//

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
