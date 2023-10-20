//
//  Date_Ext.swift
//  PaperTrader
//
//  Created by Justin Blalock on 10/15/23.
//

import Foundation

extension Date {
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute {
            return "Just now"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) m ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hrs ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        return "\(secondsAgo / week) weeks ago"
    }
    
    func timestamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    func monthDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
}

extension Int {
    func getDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
