//
//  BookmarksModel.swift
//  Hondana
//
//  Created by Kotaro Suto on 2021/10/08.
//

import Foundation

struct BookmarksPlist: Codable {
    let Root: [String: Bookmark]
}

public struct Bookmark: Codable {
    public let WebBookmarkUUID: String
    public let WebBookmarkFileVersion: Int?
    public let Children: [Bookmark]?
    public let Sync: Sync?
    public let Title: String?
    public let WebBookmarkType: String
    public let WebBookmarkIdentifier: String?
    public let ShouldOmitFromUI: Bool?
    public let URLString: String?
    public let URIDictionary: URLDictionary?
}

public struct Sync: Codable {
    public let ServerID: String?
    public let `Data`: Data?
}

public struct URLDictionary: Codable {
    public let title: String
}
