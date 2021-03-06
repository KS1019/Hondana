#if canImport(Glibc)
import Glibc
func ioctl(_ a: Int32, _ b: Int32, _ p: UnsafeMutableRawPointer) -> Int32 {
    ioctl(CInt(a), UInt(b), p)
}
#elseif canImport(Darwin)
import Darwin
#endif
import Foundation
import ArgumentParser
import HondanaKit
import Extensions

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

    @Flag(help: "List the bookmarklets as JSON")
    var asJSON = false
}

extension List {
    func run() throws {
        let jsFiles = FileSystem.bookmarkletsFolder
            .files
            .filter { $0.isBookmarklet }
        guard !jsFiles.isEmpty else {
            print("No bookmarklet exist")
            return
        }
#if canImport(AppKit)
        guard !onSafari else {
            let htmlFile = try Utils.generateHTML(from: jsFiles, in: FileSystem.hondanaFolder)
            try NSWorkspace.shared.open([htmlFile.url], withApplicationAt: Constants.List.safariAppURL, configuration: [:])
            return
        }
#endif
        var bookmarklets: [Bookmarklet]

        if asJSON {
            bookmarklets =
            try jsFiles
                .map {
                    Bookmarklet(
                        uuid: $0.nameExcludingExtension.components(separatedBy: "+").first!,
                        title: $0.nameExcludingExtension.components(separatedBy: "+")[1],
                        url: String(try $0.readAsString(encodedAs: .utf8).withoutJSPrefix)
                    )
                }
            let bookmarkletsData = Bookmarklets(bookmarklets: bookmarklets, version: "0.0.1")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(bookmarkletsData)
            print(String(data: data, encoding: .utf8)!)
        } else {
            var winsize = winsize()
            bookmarklets =
            try jsFiles
                .map {
                    Bookmarklet(
                        uuid: $0.nameExcludingExtension.components(separatedBy: "+").first!,
                        title: $0.nameExcludingExtension.components(separatedBy: "+")[1],
                        url: String(try $0.readAsString(encodedAs: .utf8)
                            .withoutJSPrefix.minified.prefix(
                                ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize) == 0 ?
                                Int(winsize.ws_col) - 30 : 30))
                    )
                }
            print(Output.render(from: bookmarklets))
        }
    }
}

extension Constants {
    enum List {
        static let commandName = "list"
        static let abstract = "`hondana list` lists every bookmarklet present in `~/.Hondana/Bookmarklets/`"
        static let discussion = "`hondana list` accesses to `~/.Hondana/Bookmarklets/`, reads the files in it, and outputs the filtered result in the table."

        static let safariAppURL = URL(string: "file://~/Applications/Safari.app")!
    }
}
