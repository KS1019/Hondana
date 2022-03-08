import struct Files.File

extension File {
    public var isBookmarklet: Bool {
        self.extension! == "js" && ((try? self.readAsString()) ?? "").hasSuffix("();\n") && self.nameExcludingExtension.contains("+")
    }
}
