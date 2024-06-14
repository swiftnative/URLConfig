//
//  NativeNetworkTests.swift
//  NativeNetworkTests
//
//  Created by Alexey Nenastev on 9.6.24..
//

import XCTest
@testable import NativeNetwork

final class NativeNetworkTests: XCTestCase {

  override func tearDown() {
    URLRequest.Config.defaultHost = ""
  }

  func testDefaultHost() async throws {

    URLRequest.Config.defaultHost = "https://dogapi.dog"

    let request = URLRequest.with {
      $0.path = "/api/v2/breeds"
    }

    let response = try await URLSession.shared.response(for: request)

    XCTAssert(response.status == .ok)
  }

  func testProvidingHostDirectly() async throws {

    let request = URLRequest.with {
      $0.host = "https://dogapi.dog"
      $0.path = "/api/v2/breeds"
    }

    let response = try await URLSession.shared.response(for: request)

    XCTAssert(response.status == .ok)
  }

  func testCustomConfig() async throws {

    let request = URLRequest.with(.dogapi) {
      $0.path = "/api/v2/breeds"
    }
    let response = try await URLSession.shared.response(for: request)

    XCTAssert(response.status == .ok)

    let request2 = URLRequest.with(.github) {
      $0.path = "/swiftnative/UnexistedRepository"
    }
    let response2 = try await URLSession.shared.response(for: request2)
    XCTAssert(response2.status == .notFound)
  }

  func testAuthorizedRequest() async throws {
    
    // First make request without auth
    let request = URLRequest.with {
      $0.host = .Host.financemodelinggrep
      $0.path = "/api/v3/search-ticker"
      $0.urlParams["query"] = "APL"
    }

    let response = try await URLSession.shared.response(for: request)

    XCTAssert(response.status == .unauthorized)

    let request2 = URLRequest.with(.finance) {
      $0.path = "/api/v3/search-ticker"
      $0.urlParams["query"] = "APL"
    }

    let response2 = try await URLSession.shared.response(for: request2)

    XCTAssert(response2.status == .ok)
  }

  func testNoSlashBetweenPathAndHost() async throws {

    let request = URLRequest.with {
      $0.host = "https://dogapi.dog"
      $0.path = "api/v2/breeds"
    }

    let response = try await URLSession.shared.response(for: request)

    XCTAssert(response.status == .ok)
  }
}

extension URLRequest.Config {
  static var dogapi = Self(host: "https://dogapi.dog")

  static var github = Self(host: "https://github.com/swiftnative/Network")

  static var finance: Self {
    var config = Self()
    config.host = .Host.financemodelinggrep
    config.urlParams["apikey"] = "kSWTdrNFTnVkZNQL03GB73etn5xpZ8TP"
    return config
  }
}

extension String {
  enum Host {
    static var financemodelinggrep = "https://financialmodelingprep.com/"
  }
}
