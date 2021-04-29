//
//  CalendarHelper.swift
//  WeekCalendar
//
//  Created by Maksim on 06/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import Foundation

protocol DateFinderProtocol {
    func getWeekBeginDate(from startWeekDay: WeekDay, date: Date) -> Date
    func getLastDayOfMonth(from date: Date) -> Date
}

class DateFinder: DateFinderProtocol {
    
    private let calendar: Calendar
    private let weekdayFactory: WeekdayFactoryProtocol
    
    init(calendar: Calendar, weekdayFactory: WeekdayFactoryProtocol) {
        self.calendar = calendar
        self.weekdayFactory = weekdayFactory
    }
    
    
    func getWeekBeginDate(from startWeekDay: WeekDay, date: Date) -> Date {
        var comps = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        comps.weekday = startWeekDay.getNumber()
        
        let todaysWeekday = weekdayFactory.create(from: date.get(.weekday))
        
        // if date points to Sunday -> show previous week
        if startWeekDay != .Sunday && todaysWeekday == .Sunday {
            comps.weekOfYear! -= 1
        }
        
        return calendar.date(from: comps)!
    }
    
    
    func getLastDayOfMonth(from date: Date) -> Date {
        return date.endOfMonth
    }
}
