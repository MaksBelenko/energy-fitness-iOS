//
//  WeedayEnumTests.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class WeedayEnumTests: XCTestCase {

    var weekday: WeekDay!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_getLocalisedName_Full() throws {
        WeekDay.allCases.forEach { weekday in
            XCTAssert(weekday.getLocalisedString(format: .Full) == weekday.rawValue)
        }
    }
    
    func test_getLocalisedName_Short() throws {
        // need only one test as test_getLocalisedName_Full()
        // covers check for all months
        weekday = .Sunday
        XCTAssert(weekday.getLocalisedString(format: .Short) == "Sun")
    }
    
    func test_getLocalisedName_OneLetter() throws {
        // need only one test as test_getLocalisedName_Full()
        // covers check for all months
        weekday = .Sunday
        XCTAssert(weekday.getLocalisedString(format: .OneLetter) == "S")
    }
    
    func test_getNumber_ReturnsCorrectWeekdayEnum() throws {
        weekday = .Sunday
        XCTAssert(weekday.getNumber() == 1, "Should be equal to 1")
        
        weekday = .Monday
        XCTAssert(weekday.getNumber() == 2, "Should be equal to 2")
        
        weekday = .Tuesday
        XCTAssert(weekday.getNumber() == 3, "Should be equal to 3")
        
        weekday = .Wednesday
        XCTAssert(weekday.getNumber() == 4, "Should be equal to 4")
        
        weekday = .Thursday
        XCTAssert(weekday.getNumber() == 5, "Should be equal to 5")
        
        weekday = .Friday
        XCTAssert(weekday.getNumber() == 6, "Should be equal to 6")
        
        weekday = .Saturday
        XCTAssert(weekday.getNumber() == 7, "Should be equal to 7")
    }

}
