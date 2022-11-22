import struct Files.File

public extension File {
    var isBookmarklet: Bool {
        self.extension! == "js" && self.nameExcludingExtension.contains("+")
    }
}
