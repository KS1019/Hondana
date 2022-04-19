import enum HondanaKit.Utils
import enum HondanaKit.FileSystem
import XCTest
import Files
import AssertSwiftCLI

final class UtilsTests: XCTestCase {
    override func setUpWithError() throws {
        try FileSystem.home.createSubfolderIfNeeded(at: ".Hondana").createSubfolderIfNeeded(at: "Bookmarklets")
    }

    override func tearDownWithError() throws {
        try FileSystem.hondanaFolder.delete()
    }

    func testGenerateHTML() throws {
        let bookmarkJS = try File(path: #file).parent!.parent!.file(at: "Fixtures/+test.js")
        let bookmarkHtml = try File(path: #file).parent!.parent!.file(at: "Fixtures/bookmarklets.html")

        let file = try Utils.generateHTML(from: [bookmarkJS], in: FileSystem.hondanaFolder)
        XCTAssertEqual(try file.readAsString().trimmingLines(), String(try bookmarkHtml.readAsString().trimmingLines().dropLast()))
    }

    func testReadJSContentsForSafariHTML() throws {
        let bookmarkHtml = try File(path: #file).parent!.parent!.file(at: "Fixtures/SafariBookmarks.html")
        try bookmarkHtml.copy(to: FileSystem.hondanaFolder)
        let bookmarks = try Utils.readJSContents(from: .safariHTML)
        XCTAssertEqual(bookmarks.count, 1)
        XCTAssertEqual(bookmarks.first!.title, "test")
        XCTAssertEqual(bookmarks.first!.url, #"(alert("testing"))();"#)
        XCTAssertEqual(bookmarks.first!.uuid, "")
    }
}
