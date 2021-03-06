//
//  ScheduleViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation
import Combine

protocol ScheduleViewModelDelegate: AnyObject {
    func reloadData()
}

protocol ScheduleViewModelProtocol {
    var delegate: ScheduleViewModelDelegate? { get set }
    
    func getViewModel(for indexPath: IndexPath) -> ScheduleCellViewModelProtocol
    func enableLoadingAnimation()
    func getNumberOfSections() -> Int
    func getNumberOfItems(for section: Int) -> Int
    func getTextForHeader(at section: Int) -> String
    func checkIfLoadingHeader() -> Bool
}


class ScheduleViewModel: ScheduleViewModelProtocol {
    
    weak var delegate: ScheduleViewModelDelegate?
    
    private var isInitialContentLoading: Bool
    
    private let networkService: NetworkServiceProtocol
    private let cellFactory: ScheduleCellVMFactoryProtocol
    private let scheduleOrganiser: ScheduleOrganiserProtocol
    
    private var organisedSessions = [OrganisedSession]()
    private var scheduleCellViewModels = [ScheduleCellViewModelProtocol]()
    
    
    // MARK: - Lifecycle
    init(
        networkService: NetworkServiceProtocol,
        cellFactory: ScheduleCellVMFactoryProtocol,
        scheduleOrganiser: ScheduleOrganiserProtocol
    ) {
        self.networkService = networkService
        self.cellFactory = cellFactory
        self.scheduleOrganiser = scheduleOrganiser
        
        isInitialContentLoading = true
        setForInitialLoadingCells()
        fetchGymClasses()
    }
    
    deinit {
        Log.logDeinit(String(describing: self))
    }
    
    
    
    // MARK: - Animation handling
    func enableLoadingAnimation() {
        delegate?.reloadData()
    }
    
    private func setForInitialLoadingCells() {
        isInitialContentLoading = true
        let dummyVM = cellFactory.createScheduleCellViewModel()
        self.scheduleCellViewModels.append(dummyVM)
    }
    
    func fetchGymClasses() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.networkService.getAllSessions { [weak self] sessions in
                guard let self = self else { return }
                self.organisedSessions = self.scheduleOrganiser.sort(sessions: sessions, by: .time)
                    self.showLoadedSessions()
            }
        }
    }
    
    private func showLoadedSessions() {
        isInitialContentLoading = false
        self.scheduleCellViewModels.removeAll()
        
        for i in 0..<organisedSessions.count {
            for _ in 0..<organisedSessions[i].sessions.count {
                let dummyVM = cellFactory.createScheduleCellViewModel()
                self.scheduleCellViewModels.append(dummyVM)
            }
        }
        
        DispatchQueue.main.async {
            for i in 0..<self.organisedSessions.count {
                let vm = self.scheduleCellViewModels[i]
                let sessions = self.organisedSessions[i].sessions
                
                for session in sessions {
                    vm.gymClassName.value = session.gymClass.name
                    vm.timePresented.value = TimePeriodFormatter().getTimePeriod(from: session.startDate, durationMins: session.durationMins)
                    vm.trainerName.value = "\(session.trainer.surname) \(session.trainer.forename.prefix(1))."
                }
            }
            
            self.delegate?.reloadData()
        }
    }
    
    
    
    // MARK: - CollectionView related
    
    func getNumberOfSections() -> Int {
        return isInitialContentLoading
                    ? 1
                    : organisedSessions.count
    }
    
    func getNumberOfItems(for section: Int) -> Int {
        return isInitialContentLoading
                    ? 10
                    : organisedSessions[section].sessions.count
    }
    
    func getViewModel(for indexPath: IndexPath) -> ScheduleCellViewModelProtocol {
        return isInitialContentLoading
                    ? scheduleCellViewModels[0]
                    : scheduleCellViewModels[indexPath.row]
    }
    
    func getTextForHeader(at section: Int) -> String {
        return isInitialContentLoading
                    ? " "
                    : organisedSessions[section].header
    }
    
    func checkIfLoadingHeader() -> Bool {
        return isInitialContentLoading
    }
}

