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
        dateComp.hour = 3 // to avoid time change
        
        return Calendar.current.date(from: dateComp)!
    }
    
    func addDays(_ number: Int) -> DateObject {
        var newDate = self
        newDate.day += number
        return newDate
    }
}

class DateObjectFactory {
    private let monthFactory = MonthFactory()
    
    func create(from date: Date) -> DateObject {
        return DateObject(day: date.get(.day),
                          month: monthFactory.create(from: date.get(.month))!,
                          year: date.get(.year))
    }
}
