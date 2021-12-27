import ArgumentParser

struct Sync: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.commandName, abstract: Constants.abstract, discussion: Constants.discussion, version: Constants.version)
}

extension Sync {
    func run() throws {
        
    }
}

extension Sync {
    enum Constants {
        static let commandName = ""
        static let abstract = ""
        static let discussion = ""
        static let version = ""
    }
}
