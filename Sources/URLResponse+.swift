//
//  File.swift
//  
//
//  Created by Alexey Nenastev on 12.6.24..
//

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
