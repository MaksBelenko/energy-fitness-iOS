//
//  Date+Ext.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func isEqualTo(_ compareDate: Date) -> Bool {
        let dateComponents = self.get(.year, .month, .day)
        let compareComponents = compareDate.get(.year, .month, .day)
        
        if dateComponents.day == compareComponents.day
            && dateComponents.month == compareComponents.month
            && dateComponents.year == compareComponents.year {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    var calendar: Calendar {
        get { return Calendar.init(identifier: .gregorian) }
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        let toDate = self.startOfMonth
        let fromDate = date.startOfMonth
        return calendar.dateComponents([.month], from: fromDate, to: toDate).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        let toDate = self.startOfDay
        let fromDate = date.startOfDay
        return calendar.dateComponents([.weekOfMonth], from: fromDate, to: toDate).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        let toDate = self.startOfDay
        let fromDate = date.startOfDay
        return calendar.dateComponents([.day], from: fromDate, to: toDate).day ?? 0
    }
}


extension Date {
    var startOfDay: Date {
        return calendar.startOfDay(for: self)
    }

    var startOfMonth: Date {
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}

