//
//  Bookmarklet.swift
//  
//
//  Created by Kotaro Suto on 2022/02/27.
//
public struct Bookmarklet {
    public var uuid: String
    public var title: String
    public var url: String

    public init(uuid: String, title: String, url: String) {
        self.uuid = uuid
        self.title = title
        self.url = url
    }
}

@_implementationOnly import Extensions
import Files

extension Bookmarklet {
    public init?(file: File) {
        guard !file.nameExcludingExtension.components(separatedBy: "+").isEmpty,
              let url = try? file.readAsString() else {
                  return nil
              }

        self.uuid = file.nameExcludingExtension.components(separatedBy: "+").first!
        self.title = file.nameExcludingExtension.components(separatedBy: "+")[1]
        self.url = url.withJSPrefix.minified
    }
}
