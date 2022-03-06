import Foundation
import Files

enum Constants {
    static let hondanaDir = ".Hondana/"
    static let bookmarkletsDir = "Bookmarklets/"

    // swiftlint:disable force_try
    static var homeFolder: Folder {
        if ProcessInfo.processInfo.environment["CI"] == nil
            && ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return Folder.temporary
        } else {
            return Folder.home
        }
    }

    static let hondanaFolder: Folder = try! homeFolder.subfolder(at: hondanaDir)
    static let bookmarkletsFolder: Folder = try! hondanaFolder.subfolder(at: bookmarkletsDir)
}
