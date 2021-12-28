import Foundation

extension String {
    public var minified: String {
        if hasPrefix("javascript:") {
            return "javascript:" + withoutJSPrefix.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        } else {
            return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        }
    }
    
    public var unminified: String {
        if hasPrefix("javascript:") {
            return "javascript:" + withoutJSPrefix.removingPercentEncoding!
        } else {
            return removingPercentEncoding!
        }
    }
    
    public var withoutJSPrefix: String {
        if hasPrefix("javascript:") {
            return String(dropFirst("javascript:".count))
        } else {
            return self
        }
    }
    
    public var withJSPrefix: String {
        if !hasPrefix("javascript:") {
            return "javascript:" + self
        } else {
            return self
        }
    }
}
