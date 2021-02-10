//
//  MonthEnumExtTests.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class MonthEnumExtTests: XCTestCase {

    var month: Month!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_getLocalisedName_Full() throws {
        Month.allCases.forEach { month in
            XCTAssert(month.getLocalisedName(format: .Full) == month.rawValue)
        }
    }
    
    func test_getLocalisedName_ThreeLetters() throws {
        // need only one test as test_getLocalisedName_Full()
        // covers check for all months
        month = .January
        XCTAssert(month.getLocalisedName(format: .ThreeLetters) == "Jan")
    }
    
    func test_getNumber_January() throws {
        month = .January
        XCTAssert(month.getNumber() == 1, "Should be equal to 1 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_February() throws {
        month = .February
        XCTAssert(month.getNumber() == 2, "Should be equal to 2 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_March() throws {
        month = .March
        XCTAssert(month.getNumber() == 3, "Should be equal to 3 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_April() throws {
        month = .April
        XCTAssert(month.getNumber() == 4, "Should be equal to 4 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_May() throws {
        month = .May
        XCTAssert(month.getNumber() == 5, "Should be equal to 5 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_June() throws {
        month = .June
        XCTAssert(month.getNumber() == 6, "Should be equal to 6 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_July() throws {
        month = .July
        XCTAssert(month.getNumber() == 7, "Should be equal to 7 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_August() throws {
        month = .August
        XCTAssert(month.getNumber() == 8, "Should be equal to 8 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_September() throws {
        month = .September
        XCTAssert(month.getNumber() == 9, "Should be equal to 9 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_October() throws {
        month = .October
        XCTAssert(month.getNumber() == 10, "Should be equal to 10 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_November() throws {
        month = .November
        XCTAssert(month.getNumber() == 11, "Should be equal to 11 but is equal to \(month.getNumber())")
    }
    
    func test_getNumber_December() throws {
        month = .December
        XCTAssert(month.getNumber() == 12, "Should be equal to 12 but is equal to \(month.getNumber())")
    }
}
