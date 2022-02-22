import XCTest
import Files
import class Foundation.Bundle

import AssertSwiftCLI

final class HondanaTests: XCTestCase {
    var hondaDirExistsPrev = false
    override func setUpWithError() throws {
        hondaDirExistsPrev = try Folder(path: "~/").containsSubfolder(named: ".Hondana")
        try Folder(path: "~").createSubfolderIfNeeded(at: ".Hondana").createSubfolderIfNeeded(at: "Bookmarklets")
    }
    
    override func tearDownWithError() throws {
        guard !hondaDirExistsPrev else { return }
        try Folder(path: "~/.Hondana").delete()
    }
    
    func testVersionFlag() throws {
        try AssertExecuteCommand(command: "hondana --version", expected: "0.0.6-d")
    }
    
    func testListWithoutJSFiles() throws {
        try AssertExecuteCommand(command: "hondana list", expected: """
            No bookmarklet exist
            """)
    }
    
    func testListWithJSFiles() throws {
        let bookmarksHtmlPath = try File(path: #file).parent!.parent!.url.appendingPathComponent("Fixtures/+test.js")
        try Folder(path: "~/.Hondana/Bookmarklets/").createFile(at: "+test.js", contents: try Data(contentsOf: bookmarksHtmlPath))
        try AssertExecuteCommand(command: "hondana list", expected: """
            +-------------------------------------------+
            | Bookmarklets                              |
            +-------------------------------------------+
            | Title | URL                               |
            +-------+-----------------------------------+
            | test  | (alert(%22testing%22))()%3B%0A... |
            +-------+-----------------------------------+
            """)
        
        try File(path: "~/.Hondana/Bookmarklets/+test.js").delete()
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
