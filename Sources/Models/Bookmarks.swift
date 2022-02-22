//
//  BookmarksModel.swift
//  Hondana
//
//  Created by Kotaro Suto on 2021/10/08.
//

import Foundation

struct BookmarksPlist: Codable {
    var Root: [String: Bookmark]
}

public struct Bookmark: Codable {
    public init(WebBookmarkUUID: String, WebBookmarkFileVersion: Int? = nil, Children: [Bookmark]? = nil, Sync: Sync? = nil, Title: String? = nil, WebBookmarkType: String, WebBookmarkIdentifier: String? = nil, ShouldOmitFromUI: Bool? = nil, URLString: String? = nil, URIDictionary: URIDictionary? = nil) {
        self.WebBookmarkUUID = WebBookmarkUUID
        self.WebBookmarkFileVersion = WebBookmarkFileVersion
        self.Children = Children
        self.Sync = Sync
        self.Title = Title
        self.WebBookmarkType = WebBookmarkType
        self.WebBookmarkIdentifier = WebBookmarkIdentifier
        self.ShouldOmitFromUI = ShouldOmitFromUI
        self.URLString = URLString
        self.URIDictionary = URIDictionary
    }

    public var WebBookmarkUUID: String
    public var WebBookmarkFileVersion: Int?
    public var Children: [Bookmark]?
    public var Sync: Sync?
    public var Title: String?
    public var WebBookmarkType: String
    public var WebBookmarkIdentifier: String?
    public var ShouldOmitFromUI: Bool?
    public var URLString: String?
    public var URIDictionary: URIDictionary?
}

public struct Sync: Codable {
    public var ServerID: String?
    public var `Data`: Data?
}

public struct URIDictionary: Codable {
    public init(title: String) {
        self.title = title
    }

    public var title: String
}
