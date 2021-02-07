//
//  DateObjectTests.swift
//  UnitTests
//
//  Created by Maksim on 07/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class DateObjectTests: XCTestCase {

    var dateObject: DateObject!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_getDays() throws {
        let dateObject = DateObject(day: 1, month: .January, year: 2021)
        let date = dateObject.getDate()

        XCTAssert(date.get(.day) == 1, "Should be equal to 6")
        XCTAssert(date.get(.month) == 1, "Month shouldnt be changed")
        XCTAssert(date.get(.year) == 2021, "Year shouldnt change")
    }

}
