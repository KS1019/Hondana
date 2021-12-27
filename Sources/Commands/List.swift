import ArgumentParser
import Foundation
import Files
import Models

struct List: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: Constants.commandName, abstract: Constants.abstract, discussion: Constants.discussion, version: Constants.version)
}

extension List {
    func run() throws {
        let data = try Data(contentsOf: URL(string: Constants.hondanaDirURL + "Bookmarks.plist")!)
        let decoder = PropertyListDecoder()
        let settings: Bookmark = try decoder.decode(Bookmark.self, from: data)
        //dump(settings)
        let root = settings.Children!.filter { child in
            return child.Children?.count != nil
        }
        
        root.forEach { child in
            if let urlString = child.URLString,
               urlString.hasPrefix("javascript")  {
                print("Title == \(child.Title!)")
                print("==============\n\n")
                print("URLString = \(urlString)")
                print("\n\n==============")
            } else {
                if let grandkids = child.Children {
                    grandkids.forEach { gk in
                        
                        if let s = gk.URLString,
                           s.hasPrefix("javascript") {
                            print("Grand Kids")
                            print("Title == \(gk.URIDictionary!.title)")
                            print("==============\n\n")
                            print("URLString = \(s)")
                            print("\n\n==============")
                        }
                    }
                }
            }
        }
    }
}

extension List {
    enum Constants {
        static let commandName = ""
        static let abstract = ""
        static let discussion = ""
        static let version = ""
        
        static let hondanaDirURL = "~/.hondana/"
    }
}
