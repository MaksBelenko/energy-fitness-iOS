//
//  DateFinderTests.swift
//  UnitTests
//
//  Created by Maksim on 07/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class DateFinderTests: XCTestCase {

    let calendar = Date.calendar
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_getWeekBeginDate_StartsMonday_ReturnsPreviousWeekMonday() throws {
        var dateComps = DateComponents()
        dateComps.year = 2021
        dateComps.month = 1
        dateComps.day = 2 // Saturday
        
        let fakeTodayDate = calendar.date(from: dateComps)!
        
        let weekdayFactory = MockWeekdayFactory(expectedWeekday: .Saturday)
        let dateFinder = DateFinder(calendar: calendar, weekdayFactory: weekdayFactory)
        
        let firstDayOfWeekDate = dateFinder.getWeekBeginDate(from: .Monday, date: fakeTodayDate)
        
        XCTAssert(firstDayOfWeekDate.get(.day) == 28, "First day is 28 (28 December 2020) but is \(firstDayOfWeekDate.get(.day))")
        XCTAssert(firstDayOfWeekDate.get(.month) == 12, "Month is 12 (28 December 2020) but is \(firstDayOfWeekDate.get(.month))")
        XCTAssert(firstDayOfWeekDate.get(.year) == 2020, "Year is 2020 (28 December 2020) but is \(firstDayOfWeekDate.get(.year))")
    }
    
    
    func test_getWeekBeginDate_StartsSunday_ReturnsSameDay() throws {
        var dateComps = DateComponents()
        dateComps.year = 2021
        dateComps.month = 1
        dateComps.day = 3 // Sunday
        
        let fakeTodayDate = calendar.date(from: dateComps)!
        
        let weekdayFactory = MockWeekdayFactory(expectedWeekday: .Sunday)
        let dateFinder = DateFinder(calendar: calendar, weekdayFactory: weekdayFactory)
        
        let firstDayOfWeekDate = dateFinder.getWeekBeginDate(from: .Sunday, date: fakeTodayDate)
        
        XCTAssert(firstDayOfWeekDate.get(.day) == 3, "First day is 3 (3 Sunday 2020) but is \(firstDayOfWeekDate.get(.day))")
        XCTAssert(firstDayOfWeekDate.get(.month) == 1, "Month is 1 (3 Sunday 2020) but is \(firstDayOfWeekDate.get(.month))")
        XCTAssert(firstDayOfWeekDate.get(.year) == 2021, "Year is 2021 (3 Sunday 2020) but is \(firstDayOfWeekDate.get(.year))")
    }
    
    
    func test_getWeekBeginDate_TodaySunday_ReturnsMonday() throws {
        var dateComps = DateComponents()
        dateComps.year = 2021
        dateComps.month = 1
        dateComps.day = 3 // Sunday
        
        let fakeTodayDate = calendar.date(from: dateComps)!
        
        let weekdayFactory = MockWeekdayFactory(expectedWeekday: .Sunday)
        let dateFinder = DateFinder(calendar: calendar, weekdayFactory: weekdayFactory)
        
        let firstDayOfWeekDate = dateFinder.getWeekBeginDate(from: .Monday, date: fakeTodayDate)
        
        XCTAssert(firstDayOfWeekDate.get(.day) == 28, "First day is 28 (28 December 2020) but is \(firstDayOfWeekDate.get(.day))")
        XCTAssert(firstDayOfWeekDate.get(.month) == 12, "Month is 12 (28 December 2020) but is \(firstDayOfWeekDate.get(.month))")
        XCTAssert(firstDayOfWeekDate.get(.year) == 2020, "Year is 2020 (28 December 2020) but is \(firstDayOfWeekDate.get(.year))")
    }
    
    
    func test_getLastDayOfMonth() throws {
        var dateComps = DateComponents()
        dateComps.year = 2021
        dateComps.month = 1
        dateComps.day = 3
        
        let fakeTodayDate = calendar.date(from: dateComps)!
        
        let weekdayFactory = MockWeekdayFactory(expectedWeekday: .Sunday)
        let dateFinder = DateFinder(calendar: calendar, weekdayFactory: weekdayFactory)
        
        let endOfMonthDate = dateFinder.getLastDayOfMonth(from: fakeTodayDate)
        
        XCTAssert(endOfMonthDate.get(.day) == 31, "Day should be 31 (31 January 2021) but is \(endOfMonthDate.get(.day))")
        XCTAssert(endOfMonthDate.get(.month) == 1, "Month should be 1 (31 January 2021) but is \(endOfMonthDate.get(.month))")
        XCTAssert(endOfMonthDate.get(.year) == 2021, "Year should be 31 (31 January 2021) but is \(endOfMonthDate.get(.year))")
    }

}
