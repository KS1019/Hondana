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
        var w = winsize()
        let bookmarklets: [(uuid: String, title: String, url: String)] =
        try Folder(path: Constants.hondanaDirURL).createSubfolderIfNeeded(at: "Bookmarklets/")
            .files
            .filter { $0.extension == "js" }
            .map { (uuid: $0.nameExcludingExtension.components(separatedBy: "+").first!,
                    title: $0.nameExcludingExtension.components(separatedBy: "+")[1],
                    url: String(try $0.readAsString(encodedAs: .utf8)
                        .withoutJSPrefix.minified.prefix(
                            ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &w) == 0 ?
                                                         Int(w.ws_col) - 30 : 30)))
            }
        guard !bookmarklets.isEmpty else {
            print("No bookmarklet exist")
            return
        }
        let titleCol = TextTableColumn(header: "Title".bold)
        let urlCol = TextTableColumn(header: "URL".bold)
        var table = TextTable(columns: [titleCol, urlCol], header: "Bookmarklets".bold)

        bookmarklets.forEach { bookmarklet in
            table.addRow(values: [bookmarklet.title, String(bookmarklet.url + "...").red])
        }

        print(table.render())
    }
}

extension List {
    enum Constants {
        static let commandName = "list"
        static let abstract = "`hondana list` lists every bookmarklet present in `~/.Hondana/Bookmarklets/`"
        static let discussion = "`hondana list` accesses to `~/.Hondana/Bookmarklets/`, reads the files in it, and outputs the filtered result in the table."

        static let hondanaDirURL = "~/.Hondana/"
    }
}
