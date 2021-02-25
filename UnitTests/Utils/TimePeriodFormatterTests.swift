//
//  TimePeriodFormatterTests.swift
//  UnitTests
//
//  Created by Maksim on 24/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class TimePeriodFormatterTests: XCTestCase {

    var calendar = Calendar.init(identifier: .gregorian)
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    
    // MARK: - Tests
    func test_getTimePeriod_enUK() throws {
        let hour = 11
        let minute = 0
        
        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 1 // expectedMonth is january in mockMonthFactory
        dateComponents.day = 3
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let date = calendar.date(from: dateComponents)!
        
        let formatter = TimePeriodFormatter()//(locale: .init(identifier: "en_GB"))
        
        let result = formatter.getTimePeriod(from: date, durationMins: 90)
        let expected = "11:00 AM - 12:30 PM"
        let expected2 = "11:00 - 12:30"
        
        XCTAssert((result == expected) || (result == expected2), "received \(result) but should be \(expected) or \(expected2)")
    }

}
