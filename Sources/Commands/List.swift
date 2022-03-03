import ArgumentParser
import Foundation
import Files
import SwiftyTextTable
import Rainbow
import Models

#if canImport(AppKit)
import AppKit
#endif

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.List.commandName,
                                                    abstract: Constants.List.abstract,
                                                    discussion: Constants.List.discussion)

#if canImport(AppKit)
    @Flag(help: "List the bookmarklets on Safari browser")
    var onSafari = false
#endif
}

extension List {
    func run() throws {
        let jsFiles = try Folder(path: Constants.hondanaDirURL)
            .createSubfolderIfNeeded(at: "Bookmarklets/")
            .files
            .filter { $0.extension == "js" }
        guard !jsFiles.isEmpty else {
            print("No bookmarklet exist")
            return
        }
        #if canImport(AppKit)
        guard !onSafari else {
            let htmlFile = try Utils.generateHTML(from: jsFiles)
            try NSWorkspace.shared.open([htmlFile.url], withApplicationAt: Constants.List.safariAppURL , configuration: [:])
            return
        }
        #endif
        var winsize = winsize()
        let bookmarklets: [(uuid: String, title: String, url: String)] =
        try jsFiles
            .map { (uuid: $0.nameExcludingExtension.components(separatedBy: "+").first!,
                    title: $0.nameExcludingExtension.components(separatedBy: "+")[1],
                    url: String(try $0.readAsString(encodedAs: .utf8)
                        .withoutJSPrefix.minified.prefix(
                            ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize) == 0 ?
                            Int(winsize.ws_col) - 30 : 30)))
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

extension Constants {
    enum List {
        static let commandName = "list"
        static let abstract = "`hondana list` lists every bookmarklet present in `~/.Hondana/Bookmarklets/`"
        static let discussion = "`hondana list` accesses to `~/.Hondana/Bookmarklets/`, reads the files in it, and outputs the filtered result in the table."

        static let hondanaDirURL = "~/.Hondana/"

        static let safariAppURL = URL(string: "file://~/Applications/Safari.app")!
    }
}
