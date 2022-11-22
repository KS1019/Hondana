//
//  Bookmarklet.swift
//
//
//  Created by Kotaro Suto on 2022/02/27.
//
public struct Bookmarklet: Codable {
    public var uuid: String
    public var title: String
    public var url: String

    public init(uuid: String, title: String, url: String) {
        self.uuid = uuid
        self.title = title
        self.url = url
    }
}

public struct Bookmarklets: Codable {
    public init(bookmarklets: [Bookmarklet], version: String, title: String? = nil, username: String? = nil, referenceURL: String? = nil) {
        self.bookmarklets = bookmarklets
        self.version = version
        self.title = title
        self.username = username
        self.referenceURL = referenceURL
    }

    public var bookmarklets: [Bookmarklet]
    public var version: String
    public var title: String?
    public var username: String?
    public var referenceURL: String?
}

@_implementationOnly import Extensions
import Files

public extension Bookmarklet {
    init?(file: File) {
        guard !file.nameExcludingExtension.components(separatedBy: "+").isEmpty,
              let url = try? file.readAsString()
        else {
            return nil
        }

        uuid = file.nameExcludingExtension.components(separatedBy: "+").first!
        title = file.nameExcludingExtension.components(separatedBy: "+")[1]
        self.url = url.withJSPrefix.minified
    }
}
