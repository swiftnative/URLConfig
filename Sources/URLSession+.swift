//
//  URLSession+.swift
//  NativeNetworking
//
//  Created by Alexey Nenastev on 8.6.24..
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation
import os

public typealias HTTPField = HTTPTypes.HTTPField

public extension URLSession {

  /// Config to make http call
  public struct Config {
    public var taskDelegate: URLSessionTaskDelegate? = defaultTaskDelegate
    public var logger: Logger? = defaultLogger

    public static var defaultTaskDelegate: URLSessionTaskDelegate?
    public static var defaultLogger = Logger.networking

    public init() {}
  }

  public typealias Configurate = (inout Config) -> Void

  @discardableResult
  func response(
    for request: URLRequest,
    config: Config = .init(),
    file: String = #file,
    function: String = #function,
    _ configurate: Configurate? = nil
  ) async throws -> DataResponse {

    var request = request
    var config = config
    configurate?(&config)

    config.logger?.debug("🛫 \(request.urlString)\n\(request.bodyString)\n📄 \(file.lastPathComponent)")
    
    do {
      let (data, urlResponse) = try await data(for: request, delegate: config.taskDelegate)

      let respones = try urlResponse.httpResponse()

      let dataResponse = DataResponse(request: request,
                                      response: respones,
                                      data: data)

      config.logger?.debug("🛬 \(dataResponse.request.urlString) \(dataResponse.status)\n\(dataResponse.bodyString)\n📄 \(file.lastPathComponent)")

      return dataResponse
    } catch {
      config.logger?.error("🛬 \(request.urlString)\n\(error)")
      throw error
    }
  }
}



extension Data {
  var json: String? {
    guard
      let JSONObject = try? JSONSerialization.jsonObject(with: self, options: []),
      JSONSerialization.isValidJSONObject(self),
      let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
      return String(data: self, encoding: .utf8)
    }
    return String(decoding: jsonData, as: UTF8.self)
  }
}

private extension String {
  var lastPathComponent: String {
    (self as NSString).lastPathComponent
  }
}
