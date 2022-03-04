import Foundation
import Files

enum Constants {
    static let rootDir = "~/"
    static let hondanaDir = ".Hondana/"
    static let bookmarkletsDir = "Bookmarklets/"

    // swiftlint:disable force_try
    static var rootFolder : Folder {
        if ProcessInfo.processInfo.environment["CI"] == nil
            && ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return Folder.temporary
        } else {
            return try! Folder(path: rootDir)
        }
    }
    
    static let hondanaFolder: Folder = try! rootFolder.subfolder(at: hondanaDir)
    static let bookmarkletsFolder: Folder = try! hondanaFolder.subfolder(at: bookmarkletsDir)
}
