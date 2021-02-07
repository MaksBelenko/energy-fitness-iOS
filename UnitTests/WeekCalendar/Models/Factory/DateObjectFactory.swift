//
//  DateObjectFactory.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class DateObjectFactoryTests: XCTestCase {

    var dateObjectFactory: DateObjectFactory!
    var calendar = Calendar.init(identifier: .gregorian)
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_create_ReturnsDateObject() throws {
        let expectedMonth = Month.January
        let mockMonthFactory = MockMonthFactory(expectedMonth: expectedMonth)
        dateObjectFactory = DateObjectFactory(monthFactory: mockMonthFactory)
        
        let year = 2021
        let day = 5
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = 1 // expectedMonth is january in mockMonthFactory
        dateComponents.day = day
        
        let date = calendar.date(from: dateComponents)!
        
        let dateObject = dateObjectFactory.create(from: date)
        
        XCTAssert(dateObject.year == year)
        XCTAssert(dateObject.month == .January) // MockMonthFactory return only january
        XCTAssert(dateObject.day == day)
        
    }
    
    func test_createByAddingDays() throws {
        let expectedMonth = Month.February
        let mockMonthFactory = MockMonthFactory(expectedMonth: expectedMonth)
        dateObjectFactory = DateObjectFactory(monthFactory: mockMonthFactory)
        
        let dateObject = DateObject(day: 31, month: .January, year: 2021)
        let newDateObject = dateObjectFactory.createByAddingDays(3, to: dateObject)
        
        XCTAssert(newDateObject.day == 3, "Should be equal to 3 but equals to \(newDateObject.day)")
        XCTAssert(newDateObject.month == expectedMonth, "Month should change to February but is equal to \(newDateObject.month)")
        XCTAssert(newDateObject.year == 2021, "Year shouldnt change")
    }
    
    func test_edgeCase_TimeChange() throws {
        let expectedMonth = Month.April
        let mockMonthFactory = MockMonthFactory(expectedMonth: expectedMonth)
        dateObjectFactory = DateObjectFactory(monthFactory: mockMonthFactory)
        
        let dateObject = DateObject(day: 27, month: .March, year: 2021)
        let newDateObject = dateObjectFactory.createByAddingDays(5, to: dateObject)
        
        XCTAssert(newDateObject.day == 1, "Should be equal to 30 but equals to \(newDateObject.day)")
        XCTAssert(newDateObject.month == expectedMonth, "Month should change to April but is equal to \(newDateObject.month)")
        XCTAssert(newDateObject.year == 2021, "Year shouldnt change")
    }

}
