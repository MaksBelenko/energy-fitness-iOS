//
//  GymSessionOrganiser.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 01/03/2021.
//

import Foundation

protocol ScheduleOrganiserProtocol {
    func sort(sessions: [GymSessionDto], by type: ScheduleFilterType) -> [OrganisedSession]
}

final class ScheduleOrganiser: ScheduleOrganiserProtocol {
    
    private let timeFormatter: TimePeriodFormatterProtocol
    
    init(timeFormatter: TimePeriodFormatterProtocol) {
        self.timeFormatter = timeFormatter
    }
    
    func sort(sessions: [GymSessionDto], by type: ScheduleFilterType) -> [OrganisedSession] {
        switch type {
            case .time:
                return sortByTime(sessions)
            case .trainer:
                return sortByTrainer(sessions)
            case .gymClass:
                return sortByGymClass(sessions)
        }
    }
    
    private func sortByTime(_ sessions: [GymSessionDto]) -> [OrganisedSession] {
        var sessionDictionary = Dictionary<Date, [GymSessionDto]>()
        
        // organise sessions in dictionary
        for session in sessions {
            let startTime = session.startDate
            
            if sessionDictionary[startTime] != nil {
                sessionDictionary[startTime]!.append(session)
            } else {
                sessionDictionary[startTime] = [session]
            }
        }
        
        let sortedDates = sessionDictionary.keys.sorted(by: { $0 < $1 })
        
        var organisedSessions = [OrganisedSession]()
        for date in sortedDates {
            let headerTime = timeFormatter.getLocalisedStringTime(from: date)
            let session = OrganisedSession(header: headerTime, sessions: sessionDictionary[date]!)
            organisedSessions.append(session)
        }
        
        return organisedSessions
    }
    
    
    private func sortByTrainer(_ sessions: [GymSessionDto]) -> [OrganisedSession] {
        var sessionDictionary = Dictionary<String, [GymSessionDto]>()
        
        // organise sessions in dictionary
        for session in sessions {
            let trainerId = session.trainer.id
            
            if sessionDictionary[trainerId] != nil {
                sessionDictionary[trainerId]!.append(session)
            } else {
                sessionDictionary[trainerId] = [session]
            }
        }
        
        var organisedSessions = [OrganisedSession]()
        let sortedIds = sessionDictionary.keys.sorted {
            let firstTrainerSurnameFirstLetter = sessionDictionary[$0]!.first!.trainer.surname.prefix(1).lowercased()
            let secondTrainerSurnameFirstLetter = sessionDictionary[$1]!.first!.trainer.surname.prefix(1).lowercased()
            return firstTrainerSurnameFirstLetter < secondTrainerSurnameFirstLetter
        }
        
        for trainerId in sortedIds {
            let trainer = sessionDictionary[trainerId]!.first!.trainer
            let trainerName = "\(trainer.forename.prefix(1)). \(trainer.surname)"
            
            let session = OrganisedSession(header: trainerName, sessions: sessionDictionary[trainerId]!)
            organisedSessions.append(session)
        }
        
        return organisedSessions
    }
    
    
    private func sortByGymClass(_ sessions: [GymSessionDto]) -> [OrganisedSession] {
        var sessionDictionary = Dictionary<String, [GymSessionDto]>()
        
        // organise sessions in dictionary
        for session in sessions {
            let gymClassId = session.gymClass.id
            
            if sessionDictionary[gymClassId] != nil {
                sessionDictionary[gymClassId]!.append(session)
            } else {
                sessionDictionary[gymClassId] = [session]
            }
        }
        
        var organisedSessions = [OrganisedSession]()
        let sortedIds = sessionDictionary.keys.sorted {
            let firstGymClassFirstLetter = sessionDictionary[$0]!.first!.gymClass.name.prefix(1).lowercased()
            let secondGymClassFirstLetter = sessionDictionary[$1]!.first!.gymClass.name.prefix(1).lowercased()
            return firstGymClassFirstLetter < secondGymClassFirstLetter
        }
        
        for gymClassId in sortedIds {
            let gymClass = sessionDictionary[gymClassId]!.first!.gymClass
            let gymClassName = gymClass.name
            
            let session = OrganisedSession(header: gymClassName, sessions: sessionDictionary[gymClassId]!)
            organisedSessions.append(session)
        }
        
        return organisedSessions
    }
}
