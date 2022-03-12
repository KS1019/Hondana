import protocol ArgumentParser.ParsableCommand
import struct ArgumentParser.CommandConfiguration
import HondanaKit

struct Install: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Install.commandName,
                                                    abstract: Constants.Install.abstract,
                                                    discussion: Constants.Install.discussion)
}

extension Install {
    func run() throws {
    }
}

extension Constants {
    enum Install {
        static let commandName = "install"
        static let abstract = "`hondana install`"
        static let discussion = "`hondana install`"
    }
}
