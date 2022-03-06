import XCTest
import Files
import class Foundation.Bundle

import AssertSwiftCLI

final class HondanaTests: XCTestCase {
    var hondaDirExistsPrev = false
    override func setUpWithError() throws {
        try Constants.rootFolder.createSubfolderIfNeeded(at: ".Hondana").createSubfolderIfNeeded(at: "Bookmarklets")
    }

    override func tearDownWithError() throws {
        try Constants.hondanaFolder.delete()
    }

    func testVersionFlag() throws {
        try AssertExecuteCommand(command: "hondana --version", expected: "0.0.6")
    }

    // swiftlint:disable line_length
    func testList() throws {
        // No Bookmarklets
        try AssertExecuteCommand(command: "hondana list", expected: "No bookmarklet exist")

        // 1 Bookmarklet
        let bookmarksHtmlPath = try File(path: #file).parent!.parent!.url.appendingPathComponent("Fixtures/+test.js")
        try Constants.bookmarkletsFolder.createFile(at: "+test.js", contents: try Data(contentsOf: bookmarksHtmlPath))
        try AssertExecuteCommand(command: "hondana list", expected: """
            +-------------------------------------------+
            | Bookmarklets                              |
            +-------------------------------------------+
            | Title | URL                               |
            +-------+-----------------------------------+
            | test  | (alert(%22testing%22))()%3B%0A... |
            +-------+-----------------------------------+
            """)

        try Constants.bookmarkletsFolder.file(named: "+test.js").delete()
    }

    func testHelp() throws {
        #if canImport(AppKit)
        try AssertExecuteCommand(command: "hondana list --help", expected: """
        OVERVIEW: `hondana list` lists every bookmarklet present in
        `~/.Hondana/Bookmarklets/`

        `hondana list` accesses to `~/.Hondana/Bookmarklets/`, reads the files in it,
        and outputs the filtered result in the table.

        USAGE: hondana list [--on-safari]

        OPTIONS:
          --on-safari             List the bookmarklets on Safari browser
          --version               Show the version.
          -h, --help              Show help information.
        """)
        #else
        try AssertExecuteCommand(command: "hondana list --help", expected: """
        OVERVIEW: `hondana list` lists every bookmarklet present in
        `~/.Hondana/Bookmarklets/`

        `hondana list` accesses to `~/.Hondana/Bookmarklets/`, reads the files in it,
        and outputs the filtered result in the table.

        USAGE: hondana list

        OPTIONS:
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

extension XCTest {
    enum Constants {
        static let rootDir = "~/"
        static let hondanaDir = ".Hondana/"
        static let bookmarkletsDir = "Bookmarklets/"
        
        // swiftlint:disable force_try
        static var rootFolder: Folder {
            if ProcessInfo.processInfo.environment["CI"] == nil
                && ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                return Folder.temporary
            } else {
                return try! Folder(path: rootDir)
            }
        }
        
        static let hondanaFolder: Folder = try! rootFolder.createSubfolderIfNeeded(at: hondanaDir)
        static let bookmarkletsFolder: Folder = try! hondanaFolder.createSubfolderIfNeeded(at: bookmarkletsDir)
    }
}
