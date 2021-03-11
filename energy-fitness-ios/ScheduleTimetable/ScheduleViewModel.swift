//
//  ScheduleViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation
import UIKit.UIImage
import Combine
import CombineDataSources

protocol ScheduleViewModelDelegate: AnyObject {
    func reloadData()
}

protocol ScheduleViewModelProtocol {
    var delegate: ScheduleViewModelDelegate? { get set }
    
    var organisedSessions: PassthroughSubject<[Section<GymSessionDto>], Never> { get set }
    
//    func getViewModel(for indexPath: IndexPath) -> ScheduleCellViewModelProtocol
//    func enableLoadingAnimation()
//    func getNumberOfSections() -> Int
//    func getNumberOfItems(for section: Int) -> Int
//    func getTextForHeader(at section: Int) -> String
//    func checkIfLoadingHeader() -> Bool
}


final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    weak var delegate: ScheduleViewModelDelegate?
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    private var isInitialContentLoading: Bool
    
    private let dataRepository: DataRepository
    private let scheduleOrganiser: ScheduleOrganiserProtocol
    
    var organisedSessions = PassthroughSubject<[Section<GymSessionDto>], Never>()
    
    private var scheduleCellViewModels = Dictionary<IndexPath, ScheduleCellViewModelProtocol>()
    
//    private lazy var dummyLoadingCellViewModel = ScheduleCellViewModel()
    
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
        
//        let dummyDto = GymSessionDto(id: "", maxNumberOfPlaces: 0,
//                                     bookedPlaces: 0,
//                                     startDate: Date(),
//                                     durationMins: 0,
//                                     gymClass: GymClassDto(id: "", name: "", description: "", photos: []),
//                                     trainer: TrainerDto(id: "", forename: "", surname: "", description: "", type: "", photos: []))
//        
//        self.organisedSessions.value = [Section(header: nil, items: [dummyDto], footer: nil, id: nil)]
        
        networkAdapter
            .fetch(returnType: [GymSessionDto].self)
            .compactMap { [weak self] in
                self?.scheduleOrganiser.sort(sessions: $0, by: .time)
            }
            .map { $0.map { Section(header: $0.header, items: $0.sessions, footer: nil, id: nil) } }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] sections in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self?.organisedSessions.send(sections)
//                    })
                    
            })
            .store(in: &subscriptions)
    }
}

