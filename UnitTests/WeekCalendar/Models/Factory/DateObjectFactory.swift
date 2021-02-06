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
        let mockMonthFactory = MockMonthFactory()
        dateObjectFactory = DateObjectFactory(monthFactory: mockMonthFactory)
    }

    override func tearDownWithError() throws {
    }

    func test_create_ReturnsDateObject() throws {
        let year = 2021
        let day = 5
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = 1 // MockMonthFactory return only january
        dateComponents.day = day
        
        let date = calendar.date(from: dateComponents)!
        
        let dateObject = dateObjectFactory.create(from: date)
        
        XCTAssert(dateObject.year == year)
        XCTAssert(dateObject.month == .January) // MockMonthFactory return only january
        XCTAssert(dateObject.day == day)
        
    }

}
