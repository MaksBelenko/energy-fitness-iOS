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
    func fetchGymClasses(for dateObject: DateObject) -> AnyPublisher<[Section<GymSessionDto>], Never>
    func changeOrder(by type: ScheduleSortType)
}

final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    var organisedSessions = CurrentValueSubject<[Section<GymSessionDto>], Never>([])
    var showNoConnectionIcon = CurrentValueSubject<Bool, Never>(false)
    var showNoEventsIcon = CurrentValueSubject<Bool, Never>(false)
    
    private var subscriptions = Set<AnyCancellable>()
    private let scheduleOrganiser: ScheduleOrganiserProtocol
    private let networkManager: NetworkManager
    
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
        scheduleOrganiser: ScheduleOrganiserProtocol,
        networkManager: NetworkManager
    ) {
        self.scheduleOrganiser = scheduleOrganiser
        self.networkManager = networkManager
//        setBindings()
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    func fetchGymClasses(for dateObject: DateObject) -> AnyPublisher<[Section<GymSessionDto>], Never> {
        return networkManager.getGymSession(for: dateObject)
            .compactMap { [weak self] in
                self?.scheduleOrganiser.sort(sessions: $0, by: .time)
            }
            .map { $0.map { Section(header: $0.header, items: $0.sessions) } }
            .handleEvents(receiveOutput: { [weak self] sections in
                self?.presentingMode = sections.isEmpty ? .noEvents : .presenting
                self?.organisedSessions.send(sections)
            }, receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: ()
                case .failure(_):
                    //TODO: make case for something went wrong
                    self?.presentingMode = .noInternetConnection
                    self?.organisedSessions.send([Section<GymSessionDto>]())
                }
            })
            .replaceError(with: [Section<GymSessionDto>]())
            .eraseToAnyPublisher()
    }
    
    /// Change order of the presented sessions
    func changeOrder(by type: ScheduleSortType) {
        DispatchQueue.global(qos: .userInteractive).async {
            let sessions = self.organisedSessions.value.flatMap { $0.items }
            if sessions.isEmpty {
                return
            }
            
            let sections = self.scheduleOrganiser.sort(sessions: sessions, by: type)
                .map { Section(header: $0.header, items: $0.sessions, footer: nil, id: nil) }
            
            self.organisedSessions.send(sections)
        }
    }
    
    
//    private func createDummySections() -> [Section<GymSessionDto>] {
//        let dummyDto1 = GymSessionDto(id: "1", maxNumberOfPlaces: 0,
//                                      bookedPlaces: 0,
//                                      startDate: Date(),
//                                      durationMins: 0,
//                                      gymClass: GymClassDto(id: "", name: "", description: "", photos: []),
//                                      trainer: TrainerDto(id: "", forename: "", surname: "", description: "", type: "", photos: []))
//
//        var dummyDto2 = dummyDto1
//        dummyDto2.id = "2"
//
//        var dummyDto3 = dummyDto1
//        dummyDto3.id = "3"
//
//        var dummyDto4 = dummyDto1
//        dummyDto4.id = "4"
//
//        return [Section(header: "", items: [dummyDto1, dummyDto2, dummyDto3, dummyDto4], footer: nil, id: nil)]
//    }
}

