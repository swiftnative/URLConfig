//
//  URLSession+.swift
//  NativeNetworking
//
//  Created by Alexey Nenastev on 8.6.24..
//

import Foundation

public extension URLSession {

  /// Config to make http call
  struct Config {
    var authorize: Bool = false

    public init() {}
  }

  /// Response with data
  struct DataResponse {
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

  private enum HTTPTypeConversionError: Error {
    case failedToConvertURLResponseToHTTPResponse
  }

  @discardableResult
  func dataResponse(
    for request: URLRequest,
    config: Config = .init(),
    file: String = #file,
    function: String = #function,
    _ configurate: (inout Config) -> Void = { _ in }
  ) async throws -> DataResponse {

    var request = request
    var config = config
    configurate(&config)

    if config.authorize {
      request.setValue("Bearer <SOME_TOKEN>", forHTTPHeaderField: "authorization")
    }

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
