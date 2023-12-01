//
//  News.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/21/23.
//

import Foundation

class News: Identifiable {
    let id: Int64
    let author: String
    let url: String
    let headline: String
    let createdAt: String
    let source: String
    
    init(id: Int64, author: String, url: String, headline: String, createdAt: String, source: String) {
        self.id = id
        self.author = author
        self.url = url
        self.headline = headline
        self.createdAt = createdAt.getDate()?.monthDay() ?? ""
        self.source = source
    }
    
    convenience init(id: Int64, author: String?, url: String?, headline: String?, createdAt: String?, source: String?) {
        self.init(id: id, author: author ?? "", url: url ?? "", headline: headline ?? "", createdAt: createdAt ?? "", source: source ?? "")
    }
}
