//
//  DateObjectFactory.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 06/02/2021.
//

import Foundation

class DateObjectFactory {
    private let monthFactory: MonthFactory
    
    init(monthFactory: MonthFactory) {
        self.monthFactory = monthFactory
    }
    
    func create(from date: Date) -> DateObject {
        return DateObject(day: date.get(.day),
                          month: monthFactory.create(from: date.get(.month))!,
                          year: date.get(.year))
    }
    
    func createByAddingDays(_ number: Int, to dateObject: DateObject) -> DateObject {
        var newDate = dateObject.getDate()
        newDate = Date.calendar.date(byAdding: .day, value: number, to: newDate)!
        
        let newDateObject = self.create(from: newDate)
        return newDateObject
    }
}
