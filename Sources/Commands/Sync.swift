import ArgumentParser
import Files

import Foundation

import Models
import Extensions

struct Sync: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.commandName, abstract: Constants.abstract, discussion: Constants.discussion, version: Constants.version)
    
    @Option(name: .shortAndLong, help: "")
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
                    (uuid: $0.name.components(separatedBy: "+").first!, title: $0.nameExcludingExtension.components(separatedBy: "+")[1], url: try! $0.readAsString(encodedAs: .utf8).withJSPrefix.minified)
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
            let folder = try! Folder(path: Constants.hondanaDirURL + Constants.bookmarkletsURL)
            
            bookmarklets
                .forEach {
                    if folder.containsFile(named: "\($0.uuid)+\($0.title).js") {
                        let file = try! folder.file(named: "\($0.uuid)+\($0.title).js")
                        try! file.write($0.url, encoding: .utf8)
                    } else {
                        try! folder.createFile(at: Constants.hondanaDirURL + Constants.bookmarkletsURL + "\($0.uuid)+\($0.title).js", contents: $0.url.data(using: .utf8))
                    }
                }
        case .plist:
            let file = try! Folder(path: Constants.hondanaDirURL).file(named: "Bookmarks.plist")
            let data = try! file.read()
            let decoder = PropertyListDecoder()
            var settings: Bookmark = try! decoder.decode(Bookmark.self, from: data)
            
            bookmarklets.forEach {
                let newBookmarklet = Bookmark(WebBookmarkUUID: $0.uuid, WebBookmarkType: "WebBookmarkTypeLeaf", URLString: $0.url, URIDictionary: URIDictionary(title: $0.title))
                settings.Children![1].Children!.insert(newBookmarklet, at: 0)
            }
            let encoder = PropertyListEncoder()
            if let encoded = try? encoder.encode(settings) {
                try! file.write(encoded)
            }
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
        static let abstract = ""
        static let discussion = ""
        static let version = ""
        
        static let bookmarkletsURL = "Bookmarklets/"
        static let hondanaDirURL = "~/.Hondana/"
    }
}
