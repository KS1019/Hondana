import Files
import Foundation
enum Utils {
    static func generateHTML(from jsFiles: [File]) throws -> File {
        let rawHTMLstring = """
            <!doctype html
            <html>
            <title>Bookmarklets</title>
            <h1>Bookmarklets</h1>
            """ +
        (try jsFiles
            .map { jsFile in
                return aTag(url: try jsFile.readAsString(encodedAs: .utf8).withJSPrefix.minified,
                            title: jsFile.nameExcludingExtension.components(separatedBy: "+")[1])
            }
            .joined(separator: "\n"))
        + """
            </html>
            """
        return try Folder(path: "~")
            .createSubfolderIfNeeded(at: ".Hondana")
            .createFile(at: "bookmarklets.html", contents: rawHTMLstring.data(using: .utf8))
    }

    private static func aTag(url: String, title: String) -> String {
        return "<a href=\"\(url)\">\(title)</a>"
    }
}
