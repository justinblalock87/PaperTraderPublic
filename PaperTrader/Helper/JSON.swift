//
//  JSON.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation

class JSON {
    static func dataToDict(data: Data) -> [String: Any] {
        var json: [String: Any]? = [:]
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        } catch {
            print("error converting to json", error)
        }
        return json ?? [:]
    }
}
