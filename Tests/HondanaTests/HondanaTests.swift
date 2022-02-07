import XCTest
import class Foundation.Bundle

import AssertSwiftCLI

final class HondanaTests: XCTestCase {
    func testVersionFlag() throws {
        try AssertExecuteCommand(command: "hondana --version", expected: "0.0.6-d")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
