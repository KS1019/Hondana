import ArgumentParser
import Files
import Foundation
import Models
import Extensions

struct Sync: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Sync.commandName,
                                                    abstract: Constants.Sync.abstract,
                                                    discussion: Constants.Sync.discussion)

    @Option(name: .shortAndLong, help: "Original source for syncing and overwriting bookmarklets in the other.")
    var from: Utils.SyncOrigin = .hondanaDir
}

extension Sync {
    func run() throws {
        let jsContent: [Utils.Bookmarklet]
        switch from {
        case .hondanaDir:
            jsContent = try Utils.readJSContents(from: .hondanaDir)
            try Utils.write(bookmarklets: jsContent, to: .plist)
        case .plist:
            jsContent = try Utils.readJSContents(from: .plist)
            try Utils.write(bookmarklets: jsContent, to: .hondanaDir)
        case .safariHTML:
            jsContent = try Utils.readJSContents(from: .safariHTML)
            try Utils.write(bookmarklets: jsContent, to: .hondanaDir)
        }
    }
}

extension Constants {
    enum Sync {
        static let commandName = "sync"
        static let abstract = "`hondana sync` syncs the JavaScript files in `~/.Hondana/Bookmarklets/` with bookmarklets in browsers"
        static let discussion = "`hondana sync` first reads the `--from` option to decide which source should be used as origin. After that, it will read the bookmarklets from the orign to sync the bookmarklets"

        static let bookmarkletsURL = "Bookmarklets/"
        static let hondanaDirURL = "~/.Hondana/"
    }
}
