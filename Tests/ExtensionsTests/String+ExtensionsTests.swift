import Extensions
import XCTest

// swiftlint:disable line_length
final class StringExtensionsTests: XCTestCase {
    let bookmarklet1 = "javascript:(function()%7B%20var%20t%20=%20document.createElement('textarea');%20var%20s%20=%20document.getSelection();%20t.textContent%20=%20%60%5B$%7B%20s.isCollapsed%20?%20document.title%20:%20s.toString()%20%7D%5D($%7B%20document.URL%20%7D)%60;%20var%20b%20=%20document.getElementsByTagName('body')%5B0%5D;%20b.appendChild(t);%20t.select();document.execCommand('copy');%20b.removeChild(t);%20%7D)();"

    let bookmarklet2 = "(function()%7Bvar%20w=550,h=420;window.open(%22https://twitter.com/intent/tweet?text=%22+encodeURIComponent(%22%F0%9F%91%80%20/%20%22%20+%20document.title)+%22%20%22+encodeURIComponent(location.href),%22_blank%22,%22width=%22+w+%22,height=%22+h+%22,left=%22+(screen.width-w)/2+%22,top=%22+(screen.height-h)/2+%22,scrollbars=yes,resizable=yes,toolbar=no,location=yes%22)%7D)()"

    func testExtensions() {
        XCTAssertEqual(bookmarklet1, bookmarklet1.unminified.minified)

        XCTAssertEqual(bookmarklet2.withJSPrefix.unminified.minified, "javascript:" + bookmarklet2)

        XCTAssertEqual(bookmarklet1.withoutJSPrefix.withJSPrefix, bookmarklet1)
    }
}
