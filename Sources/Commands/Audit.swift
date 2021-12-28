// TODO: This subcommand is currently inaccessible from cli.

import ArgumentParser

struct Audit: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.commandName, abstract: Constants.abstract, discussion: Constants.discussion)
}

extension Audit {
    func run() throws {
        
    }
}

extension Audit {
    enum Constants {
        static let commandName = ""
        static let abstract = ""
        static let discussion = ""
    }
}
