import ArgumentParser

@main
struct Hondana: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: Constants.commandName, abstract: Constants.abstract,
        discussion: Constants.discussion, version: Constants.version,
        subcommands: [
            Sync.self, List.self, Init.self
        ])
}

extension Hondana {
    enum Constants {
        static let commandName = ""
        static let abstract = ""
        static let discussion = ""
        static let version = ""
    }
}
