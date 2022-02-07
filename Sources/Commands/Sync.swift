import ArgumentParser
import Files
import Foundation
import Models
import Extensions

struct Sync: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.commandName, abstract: Constants.abstract, discussion: Constants.discussion)
    
    @Option(name: .shortAndLong, help: "Original source for syncing and overwriting bookmarklets in the other.")
    var from: SyncOrigin = .hondanaDir
}

extension Sync {
    func run() throws {
        switch from {
        case .hondanaDir:
            let jsContent = readJSContents(from: .hondanaDir)
            write(bookmarklets: jsContent, to: .plist)
        case .plist:
            let jsContent = readJSContents(from: .plist)
            write(bookmarklets: jsContent, to: .hondanaDir)
        }
    }
    
    private func readJSContents(from: SyncOrigin) -> [(uuid: String, title: String, url: String)] {
        switch from {
        case .hondanaDir:
            let folder = try! Folder(path: Constants.hondanaDirURL + Constants.bookmarkletsURL)
            let jsFiles = folder.files.filter { $0.extension == "js" }
            return jsFiles
                .map {
                    (uuid: $0.nameExcludingExtension.components(separatedBy: "+").first!, title: $0.nameExcludingExtension.components(separatedBy: "+")[1], url: try! $0.readAsString(encodedAs: .utf8).withJSPrefix.minified)
                }
        case .plist:
            let file = try! Folder(path: Constants.hondanaDirURL).file(named: "Bookmarks.plist")
            let data = try! file.read()
            let decoder = PropertyListDecoder()
            let settings: Bookmark = try! decoder.decode(Bookmark.self, from: data)
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
        }
    }
    
    private func write(bookmarklets: [(uuid: String, title: String, url: String)], to: SyncOrigin) {
        switch to {
        case .hondanaDir:
            // FIXME: This will fail when Bookmarklets/ does not exist
            // FIXME: Bookmarklets/ are assumed to be accessible. Throw an error if not.
            let folder = try! Folder(path: Constants.hondanaDirURL + Constants.bookmarkletsURL)
            
            // FIXME: This can be super slow as the number of bookmarklets grows
            bookmarklets
                .forEach { bookmarklet in
                    if folder.files.count() > 0 {
                        folder.files.forEach { file in
                            if file.nameExcludingExtension.contains(bookmarklet.uuid) {
                                try! file.rename(to: "\(bookmarklet.uuid)+\(bookmarklet.title)")
                                try! file.write(bookmarklet.url, encoding: .utf8)
                            } else {
                                try! folder.createFile(at: "\(bookmarklet.uuid)+\(bookmarklet.title).js", contents: bookmarklet.url.data(using: .utf8))
                            }
                        }
                    } else {
                        try! folder.createFile(at: "\(bookmarklet.uuid)+\(bookmarklet.title).js", contents: bookmarklet.url.data(using: .utf8))
                    }
                }
        case .plist:
            let file = try! Folder(path: Constants.hondanaDirURL).file(named: "Bookmarks.plist")
            let data = try! file.read()
            let decoder = PropertyListDecoder()
            var settings: Bookmark = try! decoder.decode(Bookmark.self, from: data)
            
            bookmarklets.forEach {
                let newBookmarklet = Bookmark(WebBookmarkUUID: $0.uuid, WebBookmarkType: "WebBookmarkTypeLeaf", URLString: $0.url, URIDictionary: URIDictionary(title: $0.title))
                if let index = settings.Children![1].Children!.firstIndex(where: { bookmarklet in newBookmarklet.WebBookmarkUUID == bookmarklet.WebBookmarkUUID }) {
                    settings.Children![1].Children![index] = newBookmarklet
                } else {
                    settings.Children![1].Children!.insert(newBookmarklet, at: 0)
                }
            }
            let encoder = PropertyListEncoder()
            let encoded = try! encoder.encode(settings)
            try! file.write(encoded)
        }
    }
}

extension Sync {
    enum SyncOrigin: String, ExpressibleByArgument {
        case hondanaDir
        case plist
    }
}

extension Sync {
    enum Constants {
        static let commandName = "sync"
        static let abstract = "`hondana sync` syncs the JavaScript files in `~/.Hondana/Bookmarklets/` with bookmarklets in `~/.Hondana/Bookmarks.plist`"
        static let discussion = "`hondana sync` first reads the `--from` option to decide whether JavaScript files or Bookmarks.plist should be used as origin. After that, it will read the bookmarklets from the orign to overwrite the ones in the other"
        
        static let bookmarkletsURL = "Bookmarklets/"
        static let hondanaDirURL = "~/.Hondana/"
    }
}
