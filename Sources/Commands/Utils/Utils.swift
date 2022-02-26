import Files
import Foundation
import ArgumentParser
import Models

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

    typealias Bookmarklet = (uuid: String, title: String, url: String)

    static func readJSContents(from: SyncOrigin) throws -> [Bookmarklet] {
        switch from {
        case .hondanaDir:
            let folder = try Folder(path: Constants.hondanaDirURL + Constants.bookmarkletsURL)
            let jsFiles = folder.files.filter { $0.extension == "js" }
            return try jsFiles
                .map {
                    (uuid: $0.nameExcludingExtension.components(separatedBy: "+").first!, title: $0.nameExcludingExtension.components(separatedBy: "+")[1], url: try $0.readAsString(encodedAs: .utf8).withJSPrefix.minified)
                }
        case .plist:
            let file = try Folder(path: Constants.hondanaDirURL).file(named: "Bookmarks.plist")
            let data = try file.read()
            let decoder = PropertyListDecoder()
            let settings: Bookmark = try decoder.decode(Bookmark.self, from: data)
            let root = settings.Children!.filter { child in
                return child.Children != nil
            }
            
            let bookmarklets = root
                .compactMap { child in
                    child.Children
                }
                .flatMap { $0 }
                .filter {
                    $0.URLString!.hasPrefix("javascript")
                }
                .map {
                    (uuid: $0.WebBookmarkUUID, title: $0.URIDictionary!.title, url: $0.URLString!.withoutJSPrefix.unminified)
                }
            
            return bookmarklets
        case .safariHTML:
            let file = try Folder(path: Constants.hondanaDirURL).files.first { $0.extension == "html" }!
            let html = String(data: try file.read(), encoding: .utf8)!
            let htmlRange = NSRange(
                html.startIndex..<html.endIndex,
                in: html
            )
            
            let regex = "<DT><A HREF=\"javascript:(.+)>(.+)</A>"
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
                    for rangeIndex in 0..<match.numberOfRanges {
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
                    (uuid: "", title: arr[2], url: arr[1])
                }
            
            return bookmarklets
        }
    }
    
    static func write(bookmarklets: [Bookmarklet], to: SyncOrigin) throws {
        switch to {
        case .hondanaDir:
            // FIXME: This will fail when Bookmarklets/ does not exist
            // FIXME: Bookmarklets/ are assumed to be accessible. Throw an error if not.
            let folder = try Folder(path: Constants.hondanaDirURL + Constants.bookmarkletsURL)
            
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
        case .plist:
            let file = try Folder(path: Constants.hondanaDirURL).file(named: "Bookmarks.plist")
            let data = try file.read()
            let decoder = PropertyListDecoder()
            var settings: Bookmark = try decoder.decode(Bookmark.self, from: data)
            
            bookmarklets.forEach {
                let newBookmarklet = Bookmark(WebBookmarkUUID: $0.uuid, WebBookmarkType: "WebBookmarkTypeLeaf", URLString: $0.url, URIDictionary: URIDictionary(title: $0.title))
                if let index = settings.Children![1].Children!.firstIndex(where: { bookmarklet in newBookmarklet.WebBookmarkUUID == bookmarklet.WebBookmarkUUID }) {
                    settings.Children![1].Children![index] = newBookmarklet
                } else {
                    settings.Children![1].Children!.insert(newBookmarklet, at: 0)
                }
            }
            let encoder = PropertyListEncoder()
            if let encoded = try? encoder.encode(settings) {
                try file.write(encoded)
            }
        case .safariHTML:
            fatalError("This Should Not Be Called")
        }
    }
    
    enum SyncOrigin: String, ExpressibleByArgument {
        case hondanaDir
        case plist
        case safariHTML
    }
}
