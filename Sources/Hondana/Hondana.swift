import ArgumentParser
import HondanaKit

@main
struct Hondana: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: Constants.Hondana.commandName, abstract: Constants.Hondana.abstract,
        discussion: Constants.Hondana.discussion, version: version,
        subcommands: [
            Add.self, Init.self, Install.self, List.self,
        ]
    )
}

extension Constants {
    enum Hondana {
        static let commandName = "hondana"
        static let abstract = "`hondana` helps you manage bookmarklets."
        static let discussion = """
        `hondana` is the root command to access other subcommands in order to manage your bookmarklets.
        """
    }
}
