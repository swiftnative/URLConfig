//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.


import Foundation
import HTTPTypes
import HTTPTypesFoundation
import os

public typealias HTTPField = HTTPTypes.HTTPField

public extension URLSession {

  /// Config to make http call
  struct Config {
    public var taskDelegate: URLSessionTaskDelegate? = defaultTaskDelegate
    public var logger: Logger? = defaultLogger
    public var logBody: Bool = logBody

    public static var defaultTaskDelegate: URLSessionTaskDelegate?
    public static var defaultLogger = Logger.networking
    public static var logBody: Bool = true
    /// Threshold for detect if response was from cache ( sec )
    public static var cacheDetectThreshold: TimeInterval = 0.05

    public init() {}
  }

  typealias Configurate = (inout Config) -> Void

  @discardableResult
  func response(
    for request: URLRequest,
    config: Config = .init(),
    file: String = #file,
    function: String = #function,
    _ configurate: Configurate? = nil
  ) async throws -> DataResponse {

    let request = request
    var config = config
    configurate?(&config)

    let reqBodyLog = config.logBody ? "\n\(request.bodyString)" : ""
    config.logger?.debug("🛫 \(request.urlString)\(reqBodyLog)\n📄 \(file.lastPathComponent)")

    do {

      let hasCachedResponse = configuration.urlCache?.cachedResponse(for: request) != nil

      let start = CFAbsoluteTimeGetCurrent()
      let (data, urlResponse) = try await data(for: request, delegate: config.taskDelegate)
      let elapsed = CFAbsoluteTimeGetCurrent() - start

      let fromCache = hasCachedResponse && elapsed < Config.cacheDetectThreshold
      let respones = try urlResponse.httpResponse()

      let dataResponse = DataResponse(request: request,
                                      response: respones,
                                      data: data,
                                      fromCache: fromCache,
                                      duration: elapsed)

      let respBodyLog = config.logBody ? "\n\(dataResponse.bodyString)" : ""
      config.logger?.debug("🛬\(fromCache ? " (from cache)" : "") \(dataResponse.request.urlString) \(dataResponse.status)\n\(respBodyLog)\n📄 \(file.lastPathComponent)")

      return dataResponse
    } catch {
      if let urlError = error as? URLError, urlError.code == .cancelled {
        config.logger?.debug("🛬 (canceled) \(request.urlString)")
        throw error
      } else if error is CancellationError {
        config.logger?.debug("🛬 (canceled) \(request.urlString)")
        throw error
      }

      config.logger?.error("🛬 \(request.urlString)\n\(error)")
      throw error
    }
  }
}

extension Data {
  var json: String? {
    guard
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
