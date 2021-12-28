import ArgumentParser
import Files

import Foundation

import Models
import Extensions

struct Init: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.commandName, abstract: Constants.abstract, discussion: Constants.discussion, version: Constants.version)
}

extension Init {
    func run() throws {
        let folder = try! Folder(path: Constants.hondanaDirURL).createSubfolder(at: Constants.bookmarkletsURL)
        if folder.isEmpty() {
            let jsContent = readJSContents()
            write(bookmarklets: jsContent)
        } else {
            print("hondana already run. Aborting Init.")
        }
    }
    
    private func readJSContents() -> [(uuid: String, title: String, url: String)] {
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
    
    private func write(bookmarklets: [(uuid: String, title: String, url: String)]) {
        let folder = try! Folder(path: Constants.hondanaDirURL + Constants.bookmarkletsURL)
        
        bookmarklets
            .forEach {
                if folder.containsFile(named: "\($0.uuid)+\($0.title).js") {
                    let file = try! folder.file(named: "\($0.uuid)+\($0.title).js")
                    try! file.write($0.url, encoding: .utf8)
                } else {
                    try! folder.createFile(at: "\($0.uuid)+\($0.title).js", contents: $0.url.data(using: .utf8))
                }
            }
    }
}

extension Init {
    enum Constants {
        static let commandName = "init"
        static let abstract = ""
        static let discussion = ""
        static let version = ""
        
        static let bookmarkletsURL = "Bookmarklets/"
        static let hondanaDirURL = "~/.Hondana/"
    }
}
