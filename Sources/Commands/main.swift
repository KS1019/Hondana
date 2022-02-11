import ArgumentParser

struct Hondana: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: Constants.commandName, abstract: Constants.abstract,
        discussion: Constants.discussion, version: version,
        subcommands: [
            Sync.self, List.self, Init.self
        ])
}

extension Hondana {
    enum Constants {
        static let commandName = "hondana"
        static let abstract = "`hondana` helps you manage bookmarklets."
        static let discussion = """
        `hondana` is the root command to access other subcommands in order to manage your bookmarklets.
        """
    }
}

Hondana.main()
