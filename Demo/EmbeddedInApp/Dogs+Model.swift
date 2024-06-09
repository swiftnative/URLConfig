//
//  Dogs+Model.swift
//  NativeNetworking
//
//  Created by Alexey Nenastev on 8.6.24..
//

import Foundation
import Observation

@Observable class Dogs {
  var breed: [Breed] = []
  var isLoading: Bool = false
  var message: String?

  // In real application you should get repository here via DI or init not instanciate it directly.
  let respository: DogsRepositoryType = DogsRepository()

  @MainActor
  func load() async {
    defer { isLoading = false }
    isLoading = true
    do {
      self.breed = try await respository.breed().data
    } catch {
      message = "\(error)"
    }
  }
}
