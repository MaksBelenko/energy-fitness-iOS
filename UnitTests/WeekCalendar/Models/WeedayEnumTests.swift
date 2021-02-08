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
    
    func test_getNumber_ForSunday() throws {
        weekday = .Sunday
        XCTAssert(weekday.getNumber() == 1, "\(weekday.rawValue) should be equal to 1")
    }
    
    func test_getNumber_ForMonday() throws {
        weekday = .Monday
        XCTAssert(weekday.getNumber() == 2, "\(weekday.rawValue) should be equal to 2")
    }
    
    func test_getNumber_ForTuesday() throws {
        weekday = .Tuesday
        XCTAssert(weekday.getNumber() == 3, "\(weekday.rawValue) should be equal to 3")
    }
    
    func test_getNumber_ForWednesday() throws {
        weekday = .Wednesday
        XCTAssert(weekday.getNumber() == 4, "\(weekday.rawValue) should be equal to 4")
    }
    
    func test_getNumber_ForThursday() throws {
        weekday = .Thursday
        XCTAssert(weekday.getNumber() == 5, "\(weekday.rawValue) should be equal to 5")
    }
    
    func test_getNumber_ForFriday() throws {
        weekday = .Friday
        XCTAssert(weekday.getNumber() == 6, "\(weekday.rawValue) should be equal to 6")
        
    }
    
    func test_getNumber_ForSaturday() throws {
        weekday = .Saturday
        XCTAssert(weekday.getNumber() == 7, "\(weekday.rawValue) should be equal to 7")
    }

}
