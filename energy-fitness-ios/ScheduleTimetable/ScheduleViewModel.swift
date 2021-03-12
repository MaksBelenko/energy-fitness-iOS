//
//  ScheduleViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ScheduleViewModelDelegate: AnyObject {
    func reloadData()
}

protocol ScheduleViewModelProtocol {
    var delegate: ScheduleViewModelDelegate? { get set }
    var organisedSessions: CurrentValueSubject<[Section<GymSessionDto>], Never> { get set }
}


final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    weak var delegate: ScheduleViewModelDelegate?
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    private var isInitialContentLoading: Bool
    
    private let dataRepository: DataRepository
    private let scheduleOrganiser: ScheduleOrganiserProtocol
    
    var organisedSessions = CurrentValueSubject<[Section<GymSessionDto>], Never>([])
    
    private let networkAdapter = URLCombine()
    
    
    // MARK: - Lifecycle
    init(
        dataRepository: DataRepository,
        scheduleOrganiser: ScheduleOrganiserProtocol
    ) {
        self.dataRepository = dataRepository
        self.scheduleOrganiser = scheduleOrganiser
        
        isInitialContentLoading = true
        fetchGymClasses()
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    
    // MARK: - Animation handling
    func enableLoadingAnimation() {
        delegate?.reloadData()
    }
    
    
    func fetchGymClasses() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//            self.organisedSessions.send(self.createDummySections())
//        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.changeOrder(by: .trainer)
        })
        
        networkAdapter
            .fetch(returnType: [GymSessionDto].self)
            .compactMap { [weak self] in
                self?.scheduleOrganiser.sort(sessions: $0, by: .time)
            }
            .map { $0.map { Section(header: $0.header, items: $0.sessions, footer: nil, id: nil) } }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] sections in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                        self?.organisedSessions.send(sections)
//                    })
                    
            })
            .store(in: &subscriptions)
    }
    
    func changeOrder(by type: ScheduleFilterType) {
        DispatchQueue.global(qos: .userInteractive).async {
            let sessions = self.organisedSessions.value.flatMap { $0.items }
            let sections = self.scheduleOrganiser.sort(sessions: sessions, by: type)
                .map { Section(header: $0.header, items: $0.sessions, footer: nil, id: nil) }
            
            self.organisedSessions.value = sections
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
        
        return [Section(header: "test", items: [dummyDto1, dummyDto2, dummyDto3, dummyDto4], footer: nil, id: nil)]
    }
}

