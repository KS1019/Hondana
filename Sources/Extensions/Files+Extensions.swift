import Files

extension File {
    public var isBookmarklet: Bool {
        self.extension! == "js" && ((try? self.readAsString()) ?? "").hasSuffix("();\n") && self.nameExcludingExtension.contains("+")
    }
}
