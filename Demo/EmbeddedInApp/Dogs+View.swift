//
// Created by Alexey Nenastyev on 4.6.24.
// Copyright © 2024 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.

import Foundation
import SwiftUI
import Observation

struct DogsList: View {
  @State private var dogs = Dogs()

  var body: some View {
    NavigationStack {
      ZStack {
        if let message = dogs.message {
          Text(message)
        }

        List(dogs.breed, id: \.id) {
          DogView(breed: $0)
        }

        if dogs.isLoading {
          ProgressView()
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Dogs")
      .task {
        await dogs.load()
      }
    }
  }
}

struct DogView: View {
  var breed: Breed

  var body: some View {
    VStack(alignment: .leading) {
      Text(breed.attributes.name)
        .font(.headline)
      Text(breed.attributes.description)
        .font(.subheadline)
    }
  }
}

#Preview {
  DogsList()
}
