//
//  Dogs+Repository.swift
//  NativeNetworking
//
//  Created by Alexey Nenastev on 8.6.24..
//

import Foundation

// Declare protocol for repository to have opportunity replace it.
protocol DogsRepositoryType {
  func breed() async throws -> Breeds
}

final class DogsRepository: DogsRepositoryType {

  func breed() async throws -> Breeds {
    let request = URLRequest.with {
      $0.method = .get
      $0.path = "/api/v2/breeds"
    }

    let dataResponse = try await URLSession.shared.dataResponse(for: request)

    return try dataResponse.decode()
  }
}

struct Breeds: Codable {
  let data: [Breed]
}

struct Breed: Codable {
  let id: String
  let type: String
  let attributes: Attributes

  struct Attributes: Codable {
    let name: String
    let description: String
  }
}
