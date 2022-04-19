import ArgumentParser
import HondanaKit

struct Init: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Init.commandName,
                                                    abstract: Constants.Init.abstract,
                                                    discussion: Constants.Init.discussion)
}

extension Init {
    func run() throws {
        try FileSystem.home
            .createSubfolderIfNeeded(at: FileSystem.hondanaDir)
            .createSubfolderIfNeeded(at: FileSystem.bookmarkletsDir)
    }
}

extension Constants {
    enum Init {
        static let commandName = "init"
        static let abstract = "`hondana init` initilizes `~/.Hondana/Bookmarklets/` directory."
        static let discussion = "`hondana init` creates `Bookmarklets/` directory if not existed already"
    }
}
