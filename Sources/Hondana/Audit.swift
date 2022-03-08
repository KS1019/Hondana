// TODO: This subcommand is currently inaccessible from cli.
import protocol ArgumentParser.ParsableCommand
import struct ArgumentParser.CommandConfiguration
import HondanaKit

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
