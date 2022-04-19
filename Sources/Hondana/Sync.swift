import protocol ArgumentParser.ParsableCommand
import struct ArgumentParser.CommandConfiguration
import struct ArgumentParser.Option
import HondanaKit
import Extensions

struct Sync: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Sync.commandName,
                                                    abstract: Constants.Sync.abstract,
                                                    discussion: Constants.Sync.discussion)
}

extension Sync {
    func run() throws {
        let jsContent: [Bookmarklet]
        jsContent = (try Utils.readJSContents(from: .safariHTML))
            .map { Bookmarklet(uuid: $0.uuid, title: $0.title, url: $0.url.unminified) }
        try Utils.write(bookmarklets: jsContent, to: .hondanaDir)
    }
}

extension Constants {
    enum Sync {
        static let commandName = "sync"
        static let abstract =
        "`hondana sync` syncs the JavaScript files in `~/.Hondana/Bookmarklets/` with bookmarklets in browsers"
        static let discussion =
        "`hondana sync` read the bookmarks from the browser or file to sync the bookmarklets"
        static let bookmarkletsURL = "Bookmarklets/"
    }
}
