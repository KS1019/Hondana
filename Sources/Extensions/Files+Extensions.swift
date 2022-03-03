import Files

extension File {
    var isBookmarklet: Bool {
        self.extension == "js" && ((try? self.readAsString()) ?? "").hasPrefix("javascript") && self.nameExcludingExtension.contains("+")
    }
}
