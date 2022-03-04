import Foundation
import Files

enum Constants {
    static let rootDir = "~/"
    static let hondanaDir = ".Hondana/"
    static let bookmarkletsDir = "Bookmarklets/"
    
    static let hondanaDirPath = rootDir + hondanaDir
    static let bookmarkletsDirPath = rootDir + hondanaDir + bookmarkletsDir

    // swiftlint: disable force_try
    static let rootFolder = try! Folder(path: rootDir)
}
