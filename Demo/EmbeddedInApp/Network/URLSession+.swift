//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.


import Foundation

public extension URLSession {

  /// Config to make http call
  struct Config {
    public init() {}
  }

  private enum HTTPTypeConversionError: Error {
    case failedToConvertURLResponseToHTTPResponse
  }

  @discardableResult
  func response(
    for request: URLRequest,
    config: Config = .init(),
    file: String = #file,
    function: String = #function,
    _ configurate: (inout Config) -> Void = { _ in }
  ) async throws -> DataResponse {

    var request = request
    var config = config
    configurate(&config)

    
    let (data, urlResponse) = try await data(for: request)
    let response = urlResponse as! HTTPURLResponse

    let dataResponse = DataResponse(request: request,
                                    response: response,
                                    data: data,
                                    status: .init(code: response.statusCode),
                                    fields: (response.allHeaderFields as? [String: String]) ?? [:])

    return dataResponse
  }
}
