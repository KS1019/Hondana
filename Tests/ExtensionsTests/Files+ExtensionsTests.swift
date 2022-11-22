import Extensions
import Files
import XCTest

// swiftlint:disable line_length
final class FilesExtensionsTests: XCTestCase {
    func testExtensions() throws {
        let bookmarksHtmlFile = try File(path: #file).parent!.parent!.file(at: "Fixtures/+test.js")

        XCTAssertTrue(bookmarksHtmlFile.isBookmarklet)
    }
}
