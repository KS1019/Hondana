import Foundation
import Extensions
import XCTest
import Files
import AssertSwiftCLI

final class UtilsTests: XCTestCase {
    override func tearDownWithError() throws {
        try Constants.hondanaFolder.files.forEach { try $0.delete() }
    }

    enum Utils {
        static func generateHTML(from jsFiles: [File]) throws -> File {
            let rawHTMLstring = """
            <!doctype html>
            <html>
            <title>Bookmarklets</title>
            <h1>Bookmarklets</h1>
            """ +
            (try jsFiles
                .map {
                    aTag(url: try $0.readAsString(encodedAs: .utf8).withJSPrefix.minified,
                         title: $0.nameExcludingExtension.components(separatedBy: "+")[1])
                }
                .joined(separator: "\n")
            )
            + """
            </html>
            """
            return try Constants.hondanaFolder
                .createFile(at: "bookmarklets.html", contents: rawHTMLstring.data(using: .utf8))
        }

        private static func aTag(url: String, title: String) -> String {
            return "<a href=\"\(url)\">\(title)</a>"
        }
    }
    
    func testGenerateHTML() throws {
        let bookmarkJS = try File(path: #file).parent!.parent!.file(at: "Fixtures/+test.js")
        let bookmarkHtml = try File(path: #file).parent!.parent!.file(at: "Fixtures/bookmarklets.html")

        let file = try Utils.generateHTML(from: [bookmarkJS])
        XCTAssertEqual(try file.readAsString().trimmingLines(), String(try bookmarkHtml.readAsString().trimmingLines().dropLast()))
    }
}
