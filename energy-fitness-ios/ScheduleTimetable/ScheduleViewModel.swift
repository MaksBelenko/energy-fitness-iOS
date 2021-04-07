//
//  ScheduleViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ScheduleViewModelProtocol {
    var organisedSessions: CurrentValueSubject<[Section<GymSessionDto>], Never> { get set }
    var showNoConnectionIcon: CurrentValueSubject<Bool, Never> { get set }
    var showNoEventsIcon: CurrentValueSubject<Bool, Never> { get set }
    func changeOrder(by type: ScheduleFilterType)
}

final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    var organisedSessions = CurrentValueSubject<[Section<GymSessionDto>], Never>([])
    
    var showNoConnectionIcon = CurrentValueSubject<Bool, Never>(false)
    var showNoEventsIcon = CurrentValueSubject<Bool, Never>(false)
    
    private var subscriptions = Set<AnyCancellable>()
    private let dataRepository: DataRepository
    private let scheduleOrganiser: ScheduleOrganiserProtocol
    private let networkAdapter = URLCombine()
    
    private var presentingMode: ScheduleShowStatus = .presenting {
        didSet {
            switch presentingMode {
            case .presenting:
                showNoConnectionIcon.send(false)
                showNoEventsIcon.send(false)
            case .noInternetConnection:
                showNoConnectionIcon.send(true)
                showNoEventsIcon.send(false)
            case .noEvents:
                showNoEventsIcon.send(true)
                showNoConnectionIcon.send(false)
            }
        }
    }
    
    
    // MARK: - Lifecycle
    init(
        dataRepository: DataRepository,
        scheduleOrganiser: ScheduleOrganiserProtocol
    ) {
        self.dataRepository = dataRepository
        self.scheduleOrganiser = scheduleOrganiser
        
        fetchGymSessions()
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    
    func fetchGymSessions() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//            self.organisedSessions.send(self.createDummySections())
//        })
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
//            self.changeOrder(by: .trainer)
//        })
        
        networkAdapter
            .fetch(returnType: [GymSessionDto].self)
            .compactMap { [weak self] in
                self?.scheduleOrganiser.sort(sessions: $0, by: .time)
            }
            .map { $0.map { Section(header: $0.header, items: $0.sessions) } }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    Log.exception(message: "Error fetching [GymSessionDto]; Error = \(error.localizedDescription)", "")
                    self?.presentingMode = .noInternetConnection
                }
            }, receiveValue: { [weak self] sections in
                    self?.organisedSessions.send(sections)
                    self?.presentingMode = .presenting
            })
            .store(in: &subscriptions)
    }
    
    func changeOrder(by type: ScheduleFilterType) {
        DispatchQueue.global(qos: .userInteractive).async {
            let sessions = self.organisedSessions.value.flatMap { $0.items }
            let sections = self.scheduleOrganiser.sort(sessions: sessions, by: type)
                .map { Section(header: $0.header, items: $0.sessions, footer: nil, id: nil) }
            
            self.organisedSessions.send(sections)
        }
    }
    
    
    private func createDummySections() -> [Section<GymSessionDto>] {
        let dummyDto1 = GymSessionDto(id: "1", maxNumberOfPlaces: 0,
                                      bookedPlaces: 0,
                                      startDate: Date(),
                                      durationMins: 0,
                                      gymClass: GymClassDto(id: "", name: "", description: "", photos: []),
                                      trainer: TrainerDto(id: "", forename: "", surname: "", description: "", type: "", photos: []))
        
        var dummyDto2 = dummyDto1
        dummyDto2.id = "2"
        
        var dummyDto3 = dummyDto1
        dummyDto3.id = "3"
        
        var dummyDto4 = dummyDto1
        dummyDto4.id = "4"
        
        return [Section(header: "", items: [dummyDto1, dummyDto2, dummyDto3, dummyDto4], footer: nil, id: nil)]
    }
}

