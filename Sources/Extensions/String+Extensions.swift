public extension String {
    var minified: String {
        if hasPrefix("javascript:") {
            return "javascript:" + withoutJSPrefix.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        } else {
            return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        }
    }

    var unminified: String {
        if hasPrefix("javascript:") {
            return "javascript:" + withoutJSPrefix.removingPercentEncoding!
        } else {
            return removingPercentEncoding!
        }
    }

    var withoutJSPrefix: String {
        if hasPrefix("javascript:") {
            return String(dropFirst("javascript:".count))
        } else {
            return self
        }
    }

    var withJSPrefix: String {
        if !hasPrefix("javascript:") {
            return "javascript:" + self
        } else {
            return self
        }
    }
}
