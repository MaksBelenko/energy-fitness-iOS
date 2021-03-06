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
