import Files
@_implementationOnly import class Foundation.ProcessInfo

public enum FileSystem {
    public static let hondanaDir = ".Hondana/"
    public static let bookmarkletsDir = "Bookmarklets/"

    // swiftlint:disable force_try
    public static var home: Folder {
        if ProcessInfo.processInfo.environment["CI"] == nil
            && ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return Folder.temporary
        } else {
            return Folder.home
        }
    }

    public static let hondanaFolder: Folder = try! home.subfolder(at: hondanaDir)
    public static let bookmarkletsFolder: Folder = try! hondanaFolder.subfolder(at: bookmarkletsDir)
}
