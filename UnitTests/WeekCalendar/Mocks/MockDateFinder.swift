//
//  MockDateFinder.swift
//  UnitTests
//
//  Created by Maksim on 07/03/2021.
//

import Foundation
@testable import EnergyFitnessApp

class MockDateFinder: DateFinderProtocol {
    
    private let weekBeginDate: Date
    private let lastDayOfMonth: Date
    
    init(weekBeginDate: Date, lastDayOfMonth: Date) {
        self.weekBeginDate = weekBeginDate
        self.lastDayOfMonth = lastDayOfMonth
    }
    
    func getWeekBeginDate(from startWeekDay: WeekDay, date: Date) -> Date {
        return weekBeginDate
    }
    
    func getLastDayOfMonth(from date: Date) -> Date {
        return lastDayOfMonth
    }
    
    
}
