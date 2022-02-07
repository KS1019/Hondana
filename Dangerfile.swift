import Danger

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

if allSourceFiles.first(where: { $0.fileType == .swift }) != nil {
    // Only modified and created files are linted.
    // See https://github.com/danger/swift/blob/d951a755f7e9335321160272698a2ede9dc572a3/Sources/Danger/Plugins/SwiftLint/SwiftLint.swift#L91
    let violation = SwiftLint.lint()
    if violation.isEmpty {
        message("No violation found!!!")
    }
}
