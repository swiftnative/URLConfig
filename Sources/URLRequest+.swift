//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.


import Foundation
import HTTPTypes
import os

public extension URLRequest {

  struct Config {
    /// Host part, can contain some path part, should start like http:// or https://
    public var host: String = defaultHost
    /// Path
    public var path: String = ""
    /// Query parameters
    public var query: [String: String] = [:]
    /// Body parameters, encoded like JSON, (use one of body or bodyModel)
    public var body: [String: Any] = [:]
    /// HTTP Method
    public var method: HTTPRequest.Method = .get
    /// Header to add to request
    public var headers = HTTPFields()
    /// `URLRequest.timeInterval`
    public var timeoutInterval: TimeInterval?
    /// Encoder for JSON body
    public var encoder = JSONEncoder()
    /// Encodable model to encoded like json in body  (use one of body or bodyModel)
    public var bodyModel: Encodable? {
      didSet {
        guard bodyModel != nil else { return }
        headers[.contentType] = "application/json"
      }
    }
    /// Some options for serialize body params
    public var options: JSONSerialization.WritingOptions = []

    /// This host will be used by default if you not specified it in Config
    public static var defaultHost: String = "https://swiftnative.com"
    
    public init(host: String = Config.defaultHost) {
      self.host = host
    }
  }

  static func with(
    _ config: Config = .init(),
    _ configurate: (inout Config) -> Void
  ) -> URLRequest {
    var config = config
    configurate(&config)
    return with(config: config)
  }

  /// Build URLRequest with config
  private static func with(config: Config) -> URLRequest {


    let separator = config.host.last != "/" && config.path.first != "/" ? "/" : ""

    let url = config.host + separator + config.path

    guard var components = URLComponents(string: url) else {
      fatalError("You provide incorrect URL components host+path: \(url)")
    }

    if !config.query.isEmpty {
      components.queryItems = config.query.map { URLQueryItem(name: $0.key, value: $0.value) }
    }

    guard let url = components.url else {
      fatalError("You provide incorrect URL components host:\(config.host) path: \(config.path)")
    }

    var request = URLRequest(url: url)
    request.httpMethod = config.method.rawValue

    if let timeoutInterval = config.timeoutInterval {
      request.timeoutInterval = timeoutInterval
    }

    if let bodyModel = config.bodyModel {
      do {
        let jsonData = try config.encoder.encode(bodyModel)
        request.httpBody = jsonData
      } catch {
        Logger.networking.error("\(error)")
      }
    }

    if !config.body.isEmpty, JSONSerialization.isValidJSONObject(config.body) {
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: config.body, options: config.options)
        request.httpBody = jsonData
      } catch {
        Logger.networking.error("\(error)")
      }
    }

    request.allHTTPHeaderFields = config.headers.dictionary

    return request
  }

  var urlString: String {
    guard let url = url else { return "" }
    return "\(httpMethod ?? "") \(url.absoluteString)"
  }

  var bodyString: String { httpBody?.json ?? "" }
}


private extension HTTPFields {
  var dictionary: [String: String] {
    var combinedFields = [HTTPField.Name: String](minimumCapacity: self.count)
    for field in self {
      if let existingValue = combinedFields[field.name] {
        let separator = field.name == .cookie ? "; " : ", "
        combinedFields[field.name] = "\(existingValue)\(separator)\(field.isoLatin1Value)"
      } else {
        combinedFields[field.name] = field.isoLatin1Value
      }
    }
    var headerFields = [String: String](minimumCapacity: combinedFields.count)
    for (name, value) in combinedFields {
      headerFields[name.rawName] = value
    }
    return headerFields
  }
}

private extension HTTPField {
  var isoLatin1Value: String {
    if self.value.isASCII {
      return self.value
    } else {
      return self.withUnsafeBytesOfValue { buffer in
        let scalars = buffer.lazy.map { UnicodeScalar(UInt32($0))! }
        var string = ""
        string.unicodeScalars.append(contentsOf: scalars)
        return string
      }
    }
  }
}

private extension String {
  var isASCII: Bool {
    self.utf8.allSatisfy { $0 & 0x80 == 0 }
  }
}
