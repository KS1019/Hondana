import Files
import class Foundation.Bundle
import XCTest

import AssertSwiftCLI
import HondanaKit

final class HondanaTests: XCTestCase {
    var hondaDirExistsPrev = false
    override func setUpWithError() throws {
        try FileSystem.home.createSubfolderIfNeeded(at: ".Hondana").createSubfolderIfNeeded(at: "Bookmarklets")
    }

    override func tearDownWithError() throws {
        try FileSystem.hondanaFolder.delete()
    }

    func testVersionFlag() throws {
        try AssertExecuteCommand(command: "hondana --version", expected: "0.0.7")
    }

    func testList() throws {
        // No Bookmarklets
        try AssertExecuteCommand(command: "hondana list", expected: "No bookmarklet exist")

        // 1 Bookmarklet
        let bookmarkletJS = try File(path: #file).parent!.parent!.file(at: "Fixtures/+test.js")
        try bookmarkletJS.copy(to: FileSystem.bookmarkletsFolder)
        try AssertExecuteCommand(command: "hondana list", expected: """
        +-------------------------------------------+
        | Bookmarklets                              |
        +-------------------------------------------+
        | Title | URL                               |
        +-------+-----------------------------------+
        | test  | (alert(%22testing%22))()%3B%0A... |
        +-------+-----------------------------------+
        """)

        try FileSystem.bookmarkletsFolder.file(named: "+test.js").delete()
    }

    func testHelp() throws {
        #if canImport(AppKit)
            try AssertExecuteCommand(command: "hondana list --help", expected: """
            OVERVIEW: `hondana list` lists every bookmarklet present in
            `~/.Hondana/Bookmarklets/`

            `hondana list` accesses to `~/.Hondana/Bookmarklets/`, reads the files in it,
            and outputs the filtered result in the table.

            USAGE: hondana list [--on-safari] [--as-json]

            OPTIONS:
              --on-safari             List the bookmarklets on Safari browser
              --as-json               List the bookmarklets as JSON
              --version               Show the version.
              -h, --help              Show help information.
            """)
        #else
            try AssertExecuteCommand(command: "hondana list --help", expected: """
            OVERVIEW: `hondana list` lists every bookmarklet present in
            `~/.Hondana/Bookmarklets/`

            `hondana list` accesses to `~/.Hondana/Bookmarklets/`, reads the files in it,
            and outputs the filtered result in the table.

            USAGE: hondana list [--as-json]

            OPTIONS:
              --as-json               List the bookmarklets as JSON
              --version               Show the version.
              -h, --help              Show help information.
            """)
        #endif
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
