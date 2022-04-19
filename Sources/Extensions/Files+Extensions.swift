import struct Files.File

extension File {
    public var isBookmarklet: Bool {
        self.extension! == "js" && self.nameExcludingExtension.contains("+")
    }
}
