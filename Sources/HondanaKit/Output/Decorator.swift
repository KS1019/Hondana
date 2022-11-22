@_implementationOnly import Rainbow
@_implementationOnly import SwiftyTextTable

public enum Output {
    public static func render(from bookmarklets: [Bookmarklet]) -> String {
        let titleCol = TextTableColumn(header: "Title".bold)
        let urlCol = TextTableColumn(header: "URL".bold)
        var table = TextTable(columns: [titleCol, urlCol], header: "Bookmarklets".bold)

        bookmarklets.forEach { bookmarklet in
            table.addRow(values: [bookmarklet.title, String(bookmarklet.url + "...").red])
        }

        return table.render()
    }
}
