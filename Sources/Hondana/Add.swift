import ArgumentParser
import Files
import HondanaKit

struct Add: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Add.commandName,
                                                    abstract: Constants.Add.abstract,
                                                    discussion: Constants.Add.discussion)

    @Argument(help: "Name for a new bookmarklet")
    var bookmarkletName: String

    var fileName: String {
        "+\(bookmarkletName).js"
    }
}

extension Add {
    func validate() throws {
        guard !bookmarkletName.isEmpty else { throw ValidationError("Bookmarklet name needs to be specified") }
        if try FileSystem.home.subfolder(at: FileSystem.hondanaDir).subfolder(at: FileSystem.bookmarkletsDir).containsFile(named: fileName) {
            throw ValidationError("\(fileName) already exists. Change Bookmarklet Name")
        }
    }

    func run() throws {
        try FileSystem.home
            .subfolder(at: FileSystem.hondanaDir)
            .subfolder(at: FileSystem.bookmarkletsDir)
            .createFile(named: fileName)
    }
}

extension Constants {
    enum Add {
        static let commandName = "add"
        static let abstract = "`hondana add` adds a new bookmarklet in `~/.Hondana/Bookmarklets/`"
        static let discussion = "`hondana add` creates a new JavaScript file in `~/.Hondana/Bookmarklets/`"
    }
}
