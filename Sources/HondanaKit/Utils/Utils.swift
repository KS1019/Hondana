@_implementationOnly import struct Foundation.NSRange
@_implementationOnly import class Foundation.NSRegularExpression
@_implementationOnly import class Foundation.PropertyListDecoder
@_implementationOnly import class Foundation.PropertyListEncoder

import ArgumentParser
import Files

public enum Utils {
    public static func generateHTML(from jsFiles: [File], in folder: Folder) throws -> File {
        let rawHTMLstring = """
        <!doctype html>
        <html>
        <head>
            <!-- Using https://github.com/xz/new.css -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@exampledev/new.css@1/new.min.css">
            <link rel="stylesheet" href="https://fonts.xz.style/serve/inter.css">
        </head>
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
        return try folder
            .createFile(at: "bookmarklets.html", contents: rawHTMLstring.data(using: .utf8))
    }

    private static func aTag(url: String, title: String) -> String {
        return "<a href=\"\(url)\"><button>\(title)</button></a>"
    }

    public static func readJSContents(from: SyncOrigin) throws -> [Bookmarklet] {
        switch from {
        case .hondanaDir:
            let folder = FileSystem.bookmarkletsFolder
            let jsFiles = folder.files.filter { $0.extension == "js" }
            return jsFiles
                .compactMap {
                    Bookmarklet(file: $0)
                }
        case .safariHTML:
            let file = FileSystem.hondanaFolder
                .files.first { $0.extension == "html" }!
            let html = String(data: try file.read(), encoding: .utf8)!
            let htmlRange = NSRange(
                html.startIndex ..< html.endIndex,
                in: html
            )

            let regex = "<DT><A HREF=\"javascript:(.+)\">(.+)</A>"
            let captureRegex = try NSRegularExpression(
                pattern: regex,
                options: []
            )

            let matches = captureRegex.matches(
                in: html,
                options: [],
                range: htmlRange
            )
            let bookmarklets: [Bookmarklet] = matches
                .compactMap { match in
                    var arr = [String]()
                    for rangeIndex in 0 ..< match.numberOfRanges {
                        let matchRange = match.range(at: rangeIndex)

                        // Ignore matching the entire username string
                        if matchRange == htmlRange { continue }

                        // Extract the substring matching the capture group
                        if let substringRange = Range(matchRange, in: html) {
                            let capture = String(html[substringRange])
                            arr.append(capture)
                        }
                    }

                    return arr
                }
                .map { (arr: [String]) in
                    Bookmarklet(uuid: "", title: arr[2], url: arr[1])
                }

            return bookmarklets
        }
    }

    public static func write(bookmarklets: [Bookmarklet], to: SyncOrigin) throws {
        switch to {
        case .hondanaDir:
            // FIXME: This will fail when Bookmarklets/ does not exist
            // FIXME: Bookmarklets/ are assumed to be accessible. Throw an error if not.
            let folder = FileSystem.bookmarkletsFolder

            // FIXME: This can be super slow as the number of bookmarklets grows
            try bookmarklets
                .forEach { bookmarklet in
                    if folder.files.count() > 0 {
                        try folder.files.forEach { file in
                            if file.nameExcludingExtension.contains(bookmarklet.uuid) {
                                try file.rename(to: "\(bookmarklet.uuid)+\(bookmarklet.title)")
                                try file.write(bookmarklet.url, encoding: .utf8)
                            } else {
                                try folder.createFile(at: "\(bookmarklet.uuid)+\(bookmarklet.title).js", contents: bookmarklet.url.data(using: .utf8))
                            }
                        }
                    } else {
                        try folder.createFile(at: "\(bookmarklet.uuid)+\(bookmarklet.title).js", contents: bookmarklet.url.data(using: .utf8))
                    }
                }
        case .safariHTML:
            fatalError("This Should Not Be Called")
        }
    }

    public enum SyncOrigin: String, ExpressibleByArgument {
        case hondanaDir
        case safariHTML
    }
}
