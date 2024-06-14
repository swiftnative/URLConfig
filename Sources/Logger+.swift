//
//  File.swift
//
//
//  Created by Alexey Nenastev on 13.6.24..
//

import Foundation
import os

public extension Logger {
  static var networking: Logger = Logger(subsystem: Bundle.nativeNetwork.bundleIdentifier ?? "",
                                         category: "networking")
}

private final class BundleClass {}

private extension Bundle {
  static var nativeNetwork: Bundle {
    Bundle(for: BundleClass.self)
  }
}
