//
//  WeekdayFactoryTests.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class WeekdayFactoryTests: XCTestCase {

    var weekdayFactory: WeekdayFactory!
    
    override func setUpWithError() throws {
        weekdayFactory = WeekdayFactory()
    }

    override func tearDownWithError() throws {
    }

    func test_create_ReturnNil_Underflow() throws {
        let weekday = weekdayFactory.create(from: 0)
        XCTAssert(weekday == nil, "Should be nil (no 0 weekday)")
    }
    
    func test_create_ReturnNil_Overflow() throws {
        let weekday = weekdayFactory.create(from: 8)
        XCTAssert(weekday == nil, "Should be nil (no 8 weekday)")
    }
    
    func test_ReturnsSunday() throws {
        let weekday = weekdayFactory.create(from: 1)
        XCTAssertNotNil(weekday, "Should NOT be nil")
        XCTAssert(weekday == .Sunday, "Month should be Sunday")
    }
    
    func test_ReturnsMonday() throws {
        let weekday = weekdayFactory.create(from: 2)
        XCTAssertNotNil(weekday, "Should NOT be nil")
        XCTAssert(weekday == .Monday, "Month should be Monday")
    }
    
    func test_ReturnsTuesday() throws {
        let weekday = weekdayFactory.create(from: 3)
        XCTAssertNotNil(weekday, "Should NOT be nil")
        XCTAssert(weekday == .Tuesday, "Month should be Tuesday")
    }
    
    func test_ReturnsWednesday() throws {
        let weekday = weekdayFactory.create(from: 4)
        XCTAssertNotNil(weekday, "Should NOT be nil")
        XCTAssert(weekday == .Wednesday, "Month should be Wednesday")
    }
    
    func test_ReturnsThursday() throws {
        let weekday = weekdayFactory.create(from: 5)
        XCTAssertNotNil(weekday, "Should NOT be nil")
        XCTAssert(weekday == .Thursday, "Month should be Thursday")
    }
    
    func test_ReturnsFriday() throws {
        let weekday = weekdayFactory.create(from: 6)
        XCTAssertNotNil(weekday, "Should NOT be nil")
        XCTAssert(weekday == .Friday, "Month should be Friday")
    }
    
    func test_ReturnsSaturday() throws {
        let weekday = weekdayFactory.create(from: 7)
        XCTAssertNotNil(weekday, "Should NOT be nil")
        XCTAssert(weekday == .Saturday, "Month should be Saturday")
    }

}
