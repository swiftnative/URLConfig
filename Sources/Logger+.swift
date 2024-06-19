//
// Created by Alexey Nenastyev on 8.6.24.
// Copyright © 2023 Alexey Nenastyev (github.com/alexejn). All Rights Reserved.

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
