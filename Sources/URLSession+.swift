//
//  URLSession+.swift
//  NativeNetworking
//
//  Created by Alexey Nenastev on 8.6.24..
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

public extension URLSession {

  struct AsyncAuthorization: Equatable {

    let call: (URLRequest) async throws -> URLRequest
    fileprivate let uid = UUID()

    public static func == (lhs: URLSession.AsyncAuthorization, rhs: URLSession.AsyncAuthorization) -> Bool {
      lhs.uid == rhs.uid
    }

    public static let no = AsyncAuthorization(call: { $0 })

    public init(call: @escaping (URLRequest) async throws -> URLRequest) {
      self.call = call
    }
  }

  /// Config to make http call
  struct Config {
    public typealias IsUnauthorized = (HTTPResponse) -> Bool
    public typealias URLSessionProvider = () -> URLSession

    public var authorization: AsyncAuthorization = defaultAuthorization
    public var isUnauthorized: IsUnauthorized = defaultIsUnauthorized

    public static var defaultAuthorization: AsyncAuthorization = .no
    public static var defaultIsUnauthorized: IsUnauthorized = { $0.status == .unauthorized  }

    public init() {}
  }

  /// Response with data
  struct DataResponse {
    public let request: URLRequest
    public let status: HTTPResponse.Status
    public let headerFields: HTTPFields
    public let data: Data
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

    if config.authorization != .no {
      request = try await config.authorization.call(request)
    }

    let (data, urlResponse) = try await data(for: request)

    guard let response = (urlResponse as? HTTPURLResponse)?.httpResponse else {
      // Its never should happen
      throw HTTPTypeConversionError.failedToConvertURLResponseToHTTPResponse
    }
    
    let dataResponse = DataResponse(request: request,
                                    status: response.status,
                                    headerFields: response.headerFields,
                                    data: data)

    return dataResponse
  }
}
