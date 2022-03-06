import ArgumentParser
import Files
import Foundation
import Models
import Extensions

struct Init: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Init.commandName,
                                                    abstract: Constants.Init.abstract,
                                                    discussion: Constants.Init.discussion)
}

extension Init {
    func run() throws {
        let folder = try Constants.homeFolder
            .createSubfolderIfNeeded(at: Constants.hondanaDir)
            .createSubfolderIfNeeded(at: Constants.bookmarkletsDir)
        if folder.isEmpty() {
            let jsContent = try Utils.readJSContents(from: .plist)
            try Utils.write(bookmarklets: jsContent, to: .hondanaDir)
        } else {
            print("hondana already run. Aborting Init.")
        }
    }
}

extension Constants {
    enum Init {
        static let commandName = "init"
        static let abstract = "`hondana init` initilizes `~/.Hondana/Bookmarklets/` directory."
        static let discussion = "`hondana init` creates `Bookmarklets/` directory if not existed already and copies the bookmarklets from `Bookmarks.plist`"
    }
}
