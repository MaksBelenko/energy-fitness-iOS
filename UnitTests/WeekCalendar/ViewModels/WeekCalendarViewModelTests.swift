//
//  WeekCalendarViewModelTests.swift
//  UnitTests
//
//  Created by Maksim on 07/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class WeekCalendarViewModelTests: XCTestCase {

    var viewModel: WeekCalendarViewModel!
    var weekData : WeekCalendarData!
    var mockDateFinder: MockDateFinder!
    var mockWeekdayFactory: MockWeekdayFactory!
    var mockMonthFactory: MockMonthFactory!
    var mockDateObjectFactory: MockDateObjectFactory!
    
    var calendar = Calendar.init(identifier: .gregorian)
    
    // MARK: - Setup & Teardown
    override func setUpWithError() throws {
        
        weekData = WeekCalendarData(numberOfWeeks: 8, startDay: .Monday, headerSpacing: 4)
        mockDateFinder = MockDateFinder(weekBeginDate: generateDate(day: 4, month: 1, year: 2021),
                                        lastDayOfMonth: generateDate(day: 31, month: 1, year: 2021))
        mockWeekdayFactory = MockWeekdayFactory(expectedWeekday: .Monday)
        mockMonthFactory = MockMonthFactory(expectedMonth: .January)
        mockDateObjectFactory = MockDateObjectFactory(createObject: DateObject(day: 1, month: .January, year: 2021),
                                                      createByAddingDaysObject: DateObject(day: 1, month: .January, year: 2021))
        
        viewModel = WeekCalendarViewModel(data: weekData,
                                          dateFinder: mockDateFinder,
                                          weekdayFactory: mockWeekdayFactory,
                                          monthFactory: mockMonthFactory,
                                          dateObjectFactory: mockDateObjectFactory)
        
        viewModel.setStartDate(to: Date())
    }

    override func tearDownWithError() throws {
    }

    // MARK: - Tests
    
//    func test_getDate() throws {
//        let expectedDateObject = DateObject(day: 3, month: .January, year: 2021)
//        mockDateObjectFactory = MockDateObjectFactory(createObject: DateObject(day: 1, month: .January, year: 2021),
//                                                      createByAddingDaysObject: expectedDateObject)
//        
//        viewModel = WeekCalendarViewModel(data: weekData,
//                                          dateFinder: mockDateFinder,
//                                          weekdayFactory: mockWeekdayFactory,
//                                          monthFactory: mockMonthFactory,
//                                          dateObjectFactory: mockDateObjectFactory)
//        viewModel.setStartDate(to: Date())
//        
//        let startDate = viewModel.getDate(from: IndexPath(row: 0, section: 0))
//        XCTAssert(startDate == expectedDateObject, "Should be expectedDateObject but is \(startDate)")
//    }
    
    // MARK: - Helper methods
    
    private func generateDate(day: Int, month: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = 1 // expectedMonth is january in mockMonthFactory
        dateComponents.day = day
        
        return calendar.date(from: dateComponents)!
    }
    
//    func setSelectedCell(indexPath: IndexPath) -> IndexPath
//    func getDate(from indexPath: IndexPath) -> DateObject
//    func getNumberOfSections() -> Int
//    func getNumberOfDays(for section: Int) -> Int
//    func getDay(for indexPath: IndexPath) -> Day
//    func getMonthName(for section: Int) -> String
//    func getMonthNameSize(for section: Int) -> CGSize
}
