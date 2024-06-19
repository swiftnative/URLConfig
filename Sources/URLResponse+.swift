//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.


import Foundation
import HTTPTypes

extension URLResponse {
  private enum HTTPTypeConversionError: Error {
      case failedToConvertHTTPRequestToURLRequest
      case failedToConvertURLResponseToHTTPResponse
  }

  func httpResponse() throws -> HTTPResponse {
    guard let response = (self as? HTTPURLResponse)?.httpResponse else {
      throw HTTPTypeConversionError.failedToConvertURLResponseToHTTPResponse
    }
    return response
  }
}
