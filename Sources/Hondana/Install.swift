import ArgumentParser
import HondanaKit
import Files

struct Install: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.Install.commandName,
                                                    abstract: Constants.Install.abstract,
                                                    discussion: Constants.Install.discussion)
    
    @Argument(help: "Experimental - `hondana install` installs an bookmarklet from remote repository on GitHub.")
    var bookmarklet: String
}

extension Install {
    func run() throws {
        let comp = bookmarklet.components(separatedBy: "/")
        if comp.count == 3 {
            let path: String
            if !Folder.temporary.containsSubfolder(at: "hondana-git-files/\(comp[0])/\(comp[1])") {
                path = try Folder.temporary.createSubfolder(at: "hondana-git-files/\(comp[0])/\(comp[1])").path
                try Git.clone(repo: comp[0]+"/"+comp[1] , path: path) {
                    let folder = try Folder(path: path)
                    let file = folder.files.filter { $0.nameExcludingExtension.contains(comp[2]) }.first!
                    let bookmarkletFile = Bookmarklet(file: file)!
                    try Utils.write(bookmarklets: [bookmarkletFile], to: .hondanaDir)
                }
            } else {
                path = try Folder.temporary.createSubfolderIfNeeded(at: "hondana-git-files/\(comp[0])/\(comp[1])").path
                try Git.pull(repo: comp[0]+"/"+comp[1] , path: path) {
                    let folder = try Folder(path: path)
                    let file = folder.files.filter { $0.nameExcludingExtension.contains(comp[2]) }.first!
                    let bookmarkletFile = Bookmarklet(file: file)!
                    try Utils.write(bookmarklets: [bookmarkletFile], to: .hondanaDir)
                }
            }
        }
    }
}

extension Constants {
    enum Install {
        static let commandName = "install"
        static let abstract = "`hondana install`"
        static let discussion = "`hondana install`"
    }
}
