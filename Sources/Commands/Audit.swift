// TODO: This subcommand is currently inaccessible from cli.

import ArgumentParser

struct Audit: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Audit.commandName,
                                                    abstract: Constants.Audit.abstract,
                                                    discussion: Constants.Audit.discussion)
}

extension Audit {
    func run() throws {

    }
}

extension Constants {
    enum Audit {
        static let commandName = ""
        static let abstract = ""
        static let discussion = ""
    }
}
