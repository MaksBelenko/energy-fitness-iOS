//
//  ScheduleOrganiserTests.swift
//  UnitTests
//
//  Created by Maksim on 01/03/2021.
//

import XCTest
@testable import EnergyFitnessApp

class ScheduleOrganiserTests: XCTestCase {

    var scheduleOrganiser: ScheduleOrganiser!
    
    // MARK: - Test data
    private lazy var date_12_00 = createDateWithTime(hour: 12, minute: 0)
    private lazy var date_13_00 = createDateWithTime(hour: 13, minute: 0)
    private lazy var date_14_30 = createDateWithTime(hour: 14, minute: 30)

    private let yoga = GymClass(id: "1", name: "Yoga", description: "", photos: [])
    private let crossfit = GymClass(id: "2", name: "Crossfit", description: "", photos: [])

    private let trainer1 = Trainer(id: "1", forename: "Maks", surname: "Belenko", description: "", type: "PERMANENT", photos: [])
    private let trainer2 = Trainer(id: "2", forename: "Alex", surname: "Alexov", description: "", type: "GUEST", photos: [])
    
    private lazy var testSessions: [GymSession] = {
        return [
        GymSession(id: "1", maxNumberOfPlaces: 5, bookedPlaces: 0, startDate: date_12_00, durationMins: 60, gymClass: yoga, trainer: trainer1),
        GymSession(id: "2", maxNumberOfPlaces: 5, bookedPlaces: 0, startDate: date_12_00, durationMins: 60, gymClass: yoga, trainer: trainer2),
        GymSession(id: "3", maxNumberOfPlaces: 5, bookedPlaces: 0, startDate: date_13_00, durationMins: 60, gymClass: crossfit, trainer: trainer2),
        GymSession(id: "4", maxNumberOfPlaces: 5, bookedPlaces: 0, startDate: date_13_00, durationMins: 60, gymClass: yoga, trainer: trainer2),
        GymSession(id: "5", maxNumberOfPlaces: 5, bookedPlaces: 0, startDate: date_14_30, durationMins: 60, gymClass: crossfit, trainer: trainer1),
        GymSession(id: "6", maxNumberOfPlaces: 5, bookedPlaces: 0, startDate: date_14_30, durationMins: 60, gymClass: yoga, trainer: trainer1),
        ]
    }()
    
    
    // MARK: - Setup & Teardown
    override func setUpWithError() throws {
        let timeFormatter = MockTimePeriodFormatter(returnValue: "---")
        scheduleOrganiser = ScheduleOrganiser(timeFormatter: timeFormatter)
    }

    override func tearDownWithError() throws {
    }

    // MARK: - Tests
    func test_filterByTime() throws {
        let organisedSessions = scheduleOrganiser.filter(sessions: testSessions, by: .time)
        
        XCTAssert(organisedSessions[0].sessions.count == 2, "At 12:00 should be 2 sessions")
        XCTAssert(organisedSessions[1].sessions.count == 2, "At 13:00 should be 2 sessions")
        XCTAssert(organisedSessions[2].sessions.count == 2, "At 14:30 should be 2 sessions")
        
        // Order the sessions should come back
        let firstSession = organisedSessions[0].sessions[0]
        let secondSession = organisedSessions[0].sessions[1]
        let thirdSession = organisedSessions[1].sessions[0]
        let fourthSession = organisedSessions[1].sessions[1]
        let fifthSession = organisedSessions[2].sessions[0]
        let sixthSession = organisedSessions[2].sessions[1]
        
        XCTAssert(firstSession.id == "1", "First session at 12:00 should have id = 1")
        XCTAssert(firstSession.startDate == date_12_00, "Session should be at 12:00")
        XCTAssert(firstSession.gymClass == yoga, "Should be yoga")
        XCTAssert(firstSession.trainer == trainer1, "Should be trainer 1")
        
        XCTAssert(secondSession.id == "2", "Second session at 12:00 should have id = 2")
        XCTAssert(secondSession.startDate == date_12_00, "Session should be at 12:00")
        XCTAssert(secondSession.gymClass == yoga, "Should be yoga")
        XCTAssert(secondSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(thirdSession.id == "3", "First session at 13:00 should have id = 3")
        XCTAssert(thirdSession.startDate == date_13_00, "Session should be at 13:00")
        XCTAssert(thirdSession.gymClass == crossfit, "Should be crossfit")
        XCTAssert(thirdSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(fourthSession.id == "4", "Second session at 13:00 should have id = 4")
        XCTAssert(fourthSession.startDate == date_13_00, "Session should be at 13:00")
        XCTAssert(fourthSession.gymClass == yoga, "Should be yoga")
        XCTAssert(fourthSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(fifthSession.id == "5", "First session at 14:30 should have id = 5")
        XCTAssert(fifthSession.startDate == date_14_30, "Session should be at 14:30")
        XCTAssert(fifthSession.gymClass == crossfit, "Should be crossfit")
        XCTAssert(fifthSession.trainer == trainer1, "Should be trainer 1")
        
        XCTAssert(sixthSession.id == "6", "Second session at 14:30 should have id = 6")
        XCTAssert(sixthSession.startDate == date_14_30, "Session should be at 14:30")
        XCTAssert(sixthSession.gymClass == yoga, "Should be yoga")
        XCTAssert(sixthSession.trainer == trainer1, "Should be trainer 1")
    }

    func test_filterByTrainer() throws {
        let organisedSessions = scheduleOrganiser.filter(sessions: testSessions, by: .trainer)
        
        XCTAssert(organisedSessions.count == 2, "Should be 2 trainers")
        XCTAssert(organisedSessions[0].sessions.count == 3, "At trainer1 should have 3 sessions")
        XCTAssert(organisedSessions[1].sessions.count == 3, "At trainer2 should have 3 sessions")
        
        XCTAssert(organisedSessions[0].header == "A. Alexov", "Name should be \"A. Alexov\" but it is \(organisedSessions[1].header)")
        XCTAssert(organisedSessions[1].header == "M. Belenko", "Name should be \"M. Belenko\" but it is \(organisedSessions[0].header)")
        
        // Order the sessions should come back
        let firstSession = organisedSessions[1].sessions[0]
        let secondSession = organisedSessions[0].sessions[0]
        let thirdSession = organisedSessions[0].sessions[1]
        let fourthSession = organisedSessions[0].sessions[2]
        let fifthSession = organisedSessions[1].sessions[1]
        let sixthSession = organisedSessions[1].sessions[2]
        
        XCTAssert(firstSession.id == "1", "First session at 12:00 should have id = 1")
        XCTAssert(firstSession.startDate == date_12_00, "Session should be at 12:00")
        XCTAssert(firstSession.gymClass == yoga, "Should be yoga")
        XCTAssert(firstSession.trainer == trainer1, "Should be trainer 1")
        
        XCTAssert(secondSession.id == "2", "Second session at 12:00 should have id = 2")
        XCTAssert(secondSession.startDate == date_12_00, "Session should be at 12:00")
        XCTAssert(secondSession.gymClass == yoga, "Should be yoga")
        XCTAssert(secondSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(thirdSession.id == "3", "First session at 13:00 should have id = 3")
        XCTAssert(thirdSession.startDate == date_13_00, "Session should be at 13:00")
        XCTAssert(thirdSession.gymClass == crossfit, "Should be crossfit")
        XCTAssert(thirdSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(fourthSession.id == "4", "Second session at 13:00 should have id = 4")
        XCTAssert(fourthSession.startDate == date_13_00, "Session should be at 13:00")
        XCTAssert(fourthSession.gymClass == yoga, "Should be yoga")
        XCTAssert(fourthSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(fifthSession.id == "5", "First session at 14:30 should have id = 5")
        XCTAssert(fifthSession.startDate == date_14_30, "Session should be at 14:30")
        XCTAssert(fifthSession.gymClass == crossfit, "Should be crossfit")
        XCTAssert(fifthSession.trainer == trainer1, "Should be trainer 1")
        
        XCTAssert(sixthSession.id == "6", "Second session at 14:30 should have id = 6")
        XCTAssert(sixthSession.startDate == date_14_30, "Session should be at 14:30")
        XCTAssert(sixthSession.gymClass == yoga, "Should be yoga")
        XCTAssert(sixthSession.trainer == trainer1, "Should be trainer 1")
    }
    
    
    func test_filterByGymClass() throws {
        let organisedSessions = scheduleOrganiser.filter(sessions: testSessions, by: .gymClass)
        
        XCTAssert(organisedSessions.count == 2, "Should be 2 different gym classes")
        
        XCTAssert(organisedSessions[0].sessions.count == 2, "At Crossfit should have 2 sessions")
        XCTAssert(organisedSessions[1].sessions.count == 4, "At Yoga should have 4 sessions")
        
        // Order the sessions should come back
        let firstSession = organisedSessions[1].sessions[0]
        let secondSession = organisedSessions[1].sessions[1]
        let thirdSession = organisedSessions[0].sessions[0]
        let fourthSession = organisedSessions[1].sessions[2]
        let fifthSession = organisedSessions[0].sessions[1]
        let sixthSession = organisedSessions[1].sessions[3]
        
        XCTAssert(firstSession.id == "1", "First session at 12:00 should have id = 1")
        XCTAssert(firstSession.startDate == date_12_00, "Session should be at 12:00")
        XCTAssert(firstSession.gymClass == yoga, "Should be yoga")
        XCTAssert(firstSession.trainer == trainer1, "Should be trainer 1")
        
        XCTAssert(secondSession.id == "2", "Second session at 12:00 should have id = 2")
        XCTAssert(secondSession.startDate == date_12_00, "Session should be at 12:00")
        XCTAssert(secondSession.gymClass == yoga, "Should be yoga")
        XCTAssert(secondSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(thirdSession.id == "3", "First session at 13:00 should have id = 3")
        XCTAssert(thirdSession.startDate == date_13_00, "Session should be at 13:00")
        XCTAssert(thirdSession.gymClass == crossfit, "Should be crossfit")
        XCTAssert(thirdSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(fourthSession.id == "4", "Second session at 13:00 should have id = 4")
        XCTAssert(fourthSession.startDate == date_13_00, "Session should be at 13:00")
        XCTAssert(fourthSession.gymClass == yoga, "Should be yoga")
        XCTAssert(fourthSession.trainer == trainer2, "Should be trainer 2")
        
        XCTAssert(fifthSession.id == "5", "First session at 14:30 should have id = 5")
        XCTAssert(fifthSession.startDate == date_14_30, "Session should be at 14:30")
        XCTAssert(fifthSession.gymClass == crossfit, "Should be crossfit")
        XCTAssert(fifthSession.trainer == trainer1, "Should be trainer 1")
        
        XCTAssert(sixthSession.id == "6", "Second session at 14:30 should have id = 6")
        XCTAssert(sixthSession.startDate == date_14_30, "Session should be at 14:30")
        XCTAssert(sixthSession.gymClass == yoga, "Should be yoga")
        XCTAssert(sixthSession.trainer == trainer1, "Should be trainer 1")
    }
    
    
    // MARK: - Performance Tests
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    
    // MARK: - Helpers
    private func createDateWithTime(hour: Int, minute: Int) -> Date {
        var dateComp = DateComponents()
        dateComp.year = 2021
        dateComp.month = 1
        dateComp.day = 3
        dateComp.hour = hour
        dateComp.minute = minute
        
        return Date.calendar.date(from: dateComp)!
    }
    
    
    // MARK: - Test Helpers
//    private func testSessions(firstSession: GymSession,
//                              secondSession: GymSession,
//                              thirdSession: GymSession,
//                              fourthSession: GymSession,
//                              fifthSession: GymSession,
//                              sixthSession: GymSession)
//    {
//        XCTAssert(firstSession.id == "1", "First session at 12:00 should have id = 1")
//        XCTAssert(firstSession.startDate == date_12_00, "Session should be at 12:00")
//        XCTAssert(firstSession.gymClass == yoga, "Should be yoga")
//        XCTAssert(firstSession.trainer == trainer1, "Should be trainer 1")
//
//
//        XCTAssert(secondSession.id == "2", "Second session at 12:00 should have id = 2")
//        XCTAssert(secondSession.startDate == date_12_00, "Session should be at 12:00")
//        XCTAssert(secondSession.gymClass == yoga, "Should be yoga")
//        XCTAssert(secondSession.trainer == trainer2, "Should be trainer 2")
//
//
//        XCTAssert(thirdSession.id == "3", "First session at 13:00 should have id = 3")
//        XCTAssert(thirdSession.startDate == date_13_00, "Session should be at 13:00")
//        XCTAssert(thirdSession.gymClass == crossfit, "Should be crossfit")
//        XCTAssert(thirdSession.trainer == trainer2, "Should be trainer 2")
//
//
//        XCTAssert(fourthSession.id == "4", "Second session at 13:00 should have id = 4")
//        XCTAssert(fourthSession.startDate == date_13_00, "Session should be at 13:00")
//        XCTAssert(fourthSession.gymClass == yoga, "Should be yoga")
//        XCTAssert(fourthSession.trainer == trainer2, "Should be trainer 2")
//
//
//        XCTAssert(fifthSession.id == "5", "First session at 14:30 should have id = 5")
//        XCTAssert(fifthSession.startDate == date_14_30, "Session should be at 14:30")
//        XCTAssert(fifthSession.gymClass == crossfit, "Should be crossfit")
//        XCTAssert(fifthSession.trainer == trainer1, "Should be trainer 1")
//
//
//        XCTAssert(sixthSession.id == "6", "Second session at 14:30 should have id = 6")
//        XCTAssert(sixthSession.startDate == date_14_30, "Session should be at 14:30")
//        XCTAssert(sixthSession.gymClass == yoga, "Should be yoga")
//        XCTAssert(sixthSession.trainer == trainer1, "Should be trainer 1")
//    }
    
}
