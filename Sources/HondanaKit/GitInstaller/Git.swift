@_implementationOnly import class Foundation.Process
@_implementationOnly import struct Foundation.URL
import Files

public class Git {
    private static let url = URL(fileURLWithPath: "/usr/bin/git")
    public let exists: Bool = (try? File(path: "/usr/bin/git")) != nil
    private static let process =  Process()
    public static func clone(repo: String, path: String) throws {
        process.executableURL = url
        process.arguments = ["clone", "https://github.com/" + repo + ".git", path]
        try process.run()
    }
}
