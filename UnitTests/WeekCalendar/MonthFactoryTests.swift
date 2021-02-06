//
//  MonthFactoryTests.swift
//  UnitTests
//
//  Created by Maksim on 06/02/2021.
//

import XCTest
@testable import EnergyFitnessApp

class MonthFactoryTests: XCTestCase {

    var monthFactory: MonthFactory!
    
    override func setUpWithError() throws {
        monthFactory = MonthFactory()
    }

    override func tearDownWithError() throws {
    }
    
    func test_create_ReturnNil_Underflow() throws {
        let month = monthFactory.create(from: 0)
        XCTAssert(month == nil, "Should be nil (no 0 month)")
    }
    
    func test_create_ReturnNil_Overflow() throws {
        let month = monthFactory.create(from: 13)
        XCTAssert(month == nil, "Should be nil (no 13 month)")
    }

    func test_create_ReturnJanuary() throws {
        let month = monthFactory.create(from: 1)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .January, "Month should be January")
    }
    
    func create_ReturnFebruary() throws {
        let month = monthFactory.create(from: 2)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .February, "Month should be February")
    }
    
    func test_create_ReturnMarch() throws {
        let month = monthFactory.create(from: 3)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .March, "Month should be March")
    }
    
    func test_create_ReturnApril() throws {
        let month = monthFactory.create(from: 4)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .April, "Month should be April")
    }
    
    func test_create_ReturnMay() throws {
        let month = monthFactory.create(from: 5)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .May, "Month should be May")
    }
    
    func test_create_ReturnJune() throws {
        let month = monthFactory.create(from: 6)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .June, "Month should be June")
    }
    
    func test_create_ReturnJuly() throws {
        let month = monthFactory.create(from: 7)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .July, "Month should be July")
    }
    
    func test_create_ReturnAugust() throws {
        let month = monthFactory.create(from: 8)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .August, "Month should be August")
    }
    
    func test_create_ReturnSeptember() throws {
        let month = monthFactory.create(from: 9)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .September, "Month should be September")
    }
    
    func test_create_ReturnOctober() throws {
        let month = monthFactory.create(from: 10)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .October, "Month should be October")
    }
    
    func test_create_ReturnNovember() throws {
        let month = monthFactory.create(from: 11)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .November, "Month should be November")
    }
    
    func test_create_ReturnDecember() throws {
        let month = monthFactory.create(from: 12)
        XCTAssertNotNil(month, "Should NOT be nil")
        XCTAssert(month == .December, "Month should be December")
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
