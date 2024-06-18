//
//  File.swift
//
//
//  Created by Alexey Nenastev on 12.6.24..
//

import Foundation

public extension URLRequest {

  struct File {
    public var key: String
    public let name: String
    public let data: Data
    public let mimeType: String

    public init(key: String = "", name: String, data: Data, mimeType: String) {
      self.key = key
      self.name = name
      self.data = data
      self.mimeType = mimeType
    }
  }

  mutating func setMultipartFormData(parameters: [String: String], files: [File]) {
    let boundary = "Boundary-\(UUID().uuidString)"
    let contentType = "multipart/form-data; boundary=\(boundary)"
    self.addValue(contentType, forHTTPHeaderField: "Content-Type")

    let body = createBody(boundary: boundary, parameters: parameters, files: files)
    self.httpBody = body
    self.setValue(String(body.count), forHTTPHeaderField: "Content-Length")
  }

  private func createBody(boundary: String, parameters: [String: String], files: [File]) -> Data {
    var body = Data()

    let boundaryPrefix = "--\(boundary)\r\n"

    for (key, value) in parameters {
      body.append(boundaryPrefix)
      body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
      body.append("\(value)\r\n")
    }

    for file in files {
      body.append(boundaryPrefix)
      body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\r\n")
      body.append("Content-Type: \(file.mimeType)\r\n\r\n")
      body.append(file.data)
      body.append("\r\n")
    }

    body.append("--\(boundary)--\r\n")

    return body
  }
}

private extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
