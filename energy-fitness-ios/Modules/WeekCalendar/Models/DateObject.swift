//
//  DateObject.swift
//  WeekCalendar
//
//  Created by Maksim on 29/11/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import Foundation

struct DateObject {
    var day: Int
    let month: Month
    let year: Int
    
    func getDate() -> Date {
        var dateComp = DateComponents()
        dateComp.year = self.year
        dateComp.month = self.month.getNumber()
        dateComp.day = self.day
        dateComp.hour = 3 // to avoid time change for dateObject
        
        return Date.calendar.date(from: dateComp)!
    }
}

extension DateObject {
    static func ==(lhs: DateObject, rhs: DateObject) -> Bool {
        return lhs.day == rhs.day
            && lhs.month == rhs.month
            && lhs.year == rhs.year
    }
}

extension DateObject {
    func getStartDateIsoString() -> String {
        var dateComp = DateComponents()
        dateComp.year = self.year
        dateComp.month = self.month.getNumber()
        dateComp.day = self.day
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        
        let date = Date.calendar.date(from: dateComp)!
        return date.iso8601withFractionalSeconds
    }
    
    func getEndDateIsoString() -> String {
        var dateComp = DateComponents()
        dateComp.year = self.year
        dateComp.month = self.month.getNumber()
        dateComp.day = self.day
        dateComp.hour = 23
        dateComp.minute = 59
        dateComp.second = 59
        
        let date = Date.calendar.date(from: dateComp)!
        return date.iso8601withFractionalSeconds
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
