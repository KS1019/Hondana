import ArgumentParser
import Foundation
import Files
import SwiftyTextTable
import Rainbow
import Models

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.commandName, abstract: Constants.abstract, discussion: Constants.discussion)
}

extension List {
    func run() throws {
        let file = try! Folder(path: Constants.hondanaDirURL).file(named: "Bookmarks.plist")
        let data = try! file.read()
        let decoder = PropertyListDecoder()
        let settings: Bookmark = try decoder.decode(Bookmark.self, from: data)
        let root = settings.Children!.filter { child in
            return child.Children != nil
        }
        var w = winsize()
        let bookmarklets = root
            .compactMap { child in
                child.Children
            }
            .flatMap { $0 }
            .map {
                (title: $0.URIDictionary?.title, url: $0.URLString?.prefix(ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &w) == 0 ? Int(w.ws_col) - 30 : 30))
            }
            .filter {
                $0.url!.hasPrefix("javascript")
            }
        let titleCol = TextTableColumn(header: "Title".bold)
        let urlCol = TextTableColumn(header: "URL".bold)
        var table = TextTable(columns: [titleCol, urlCol], header: "Bookmarklets".bold)
        
        bookmarklets.forEach { bookmarklet in
            table.addRow(values: [bookmarklet.title!, String(bookmarklet.url! + "...").red])
        }
        
        print(table.render())
    }
}

extension List {
    enum Constants {
        static let commandName = "list"
        static let abstract = "`hondana list` lists every bookmarklet present in `Bookmarks.plist`"
        static let discussion = "`hondana list` accesses to `~/.Hondana/Bookmarks.plist`, reads the plist, and outputs the filtered result in the table."
        
        static let hondanaDirURL = "~/.Hondana/"
    }
}
