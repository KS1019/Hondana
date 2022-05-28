import Foundation
import Files

public class Git {
    private static let url = URL(fileURLWithPath: "/usr/bin/git")
    public let exists: Bool = (try? File(path: "/usr/bin/git")) != nil
    private static let process = Process()
    public static func clone(repo: String, path: String, closure: @escaping () throws -> Void) throws {
        process.executableURL = url
        process.arguments = ["clone", "https://github.com/" + repo + ".git", path, "-q"]
        process.terminationHandler = { process in
            if process.terminationStatus == 0 {
                try? closure()
            }
        }
        try process.run()
        process.waitUntilExit()
    }
    
    public static func pull(repo: String, path: String, closure: @escaping () throws -> Void) throws {
        FileManager.default.changeCurrentDirectoryPath(path)
        process.executableURL = url
        process.arguments = ["pull"]
        process.terminationHandler = { process in
            if process.terminationStatus == 0 {
                try? closure()
            }
        }
        try process.run()
        process.waitUntilExit()
    }
}
