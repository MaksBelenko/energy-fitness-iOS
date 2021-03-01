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
//    var isTextLoading: Bool { get set }
    var delegate: ScheduleViewModelDelegate? { get set }
    
    func getViewModel(for indexPath: IndexPath) -> ScheduleCellViewModelProtocol
    func enableLoadingAnimation()
    func getNumberOfSections() -> Int
    func getNumberOfItems(for section: Int) -> Int
    func getTextForHeader(at section: Int) -> String
}


class ScheduleViewModel: ScheduleViewModelProtocol {
    
    weak var delegate: ScheduleViewModelDelegate?
    
    private let networkService: NetworkServiceProtocol
    private let cellFactory: ScheduleCellVMFactoryProtocol
    private let scheduleOrganiser: ScheduleOrganiserProtocol
    
    private var gymSessions = [GymSession]()
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
        
        
        showLoadingCells()
        fetchGymClasses()
    }
    
    deinit {
        Log.logDeinit(String(describing: self))
    }
    
    
    
    // MARK: - Animation handling
    func enableLoadingAnimation() {
        delegate?.reloadData()
    }
    
    private func showLoadingCells() {
        for _ in 1...10 {
            let dummyVM = cellFactory.createScheduleCellViewModel(textData: nil, trainerImage: nil)
            self.scheduleCellViewModels.append(dummyVM)
        }
    }
    
    func fetchGymClasses() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.networkService.getAllSessions { [weak self] sessions in
                guard let self = self else { return }
                self.gymSessions = sessions
//                DispatchQueue.main.async {
                    self.showSessions()
//                }
            }
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
//            self.scheduleCellViewModels.removeAll()
//
//            showLoadingCells()
//            self.delegate?.reloadData()
//            self.scheduleCellViewModels.forEach { $0.gymClassName.send("Test class name-------") }
//            self.scheduleCellViewModels[0].timePresented.send("11:00 AM - 12:00 PM")
//            self.scheduleCellViewModels[0].trainerName.send("Жгилева В.")
//            self.scheduleCellViewModels[0].trainerImage.send(#imageLiteral(resourceName: "general"))
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
//                var count = 0
//                for viewModel in scheduleCellViewModels {
//                    viewModel.gymClassName.send("\(count)")
//                    count += 1
//                }
//
//                self.scheduleCellViewModels[7].timePresented.send("qweqweqweqwe")
//                self.scheduleCellViewModels[7].trainerName.send("dsdfsdfsdf.")
//                self.scheduleCellViewModels[7].trainerImage.send(#imageLiteral(resourceName: "nosessions"))
//            }
//        }
    }
    
    private func showSessions() {
        
        self.scheduleCellViewModels.removeAll()
        for _ in 0..<gymSessions.count {
            let dummyVM = cellFactory.createScheduleCellViewModel(textData: nil, trainerImage: nil)
            self.scheduleCellViewModels.append(dummyVM)
        }
        
        DispatchQueue.main.async {
            for i in 0..<self.gymSessions.count {
                let vm = self.scheduleCellViewModels[i]
                let session = self.gymSessions[i]
                
                vm.gymClassName.value = session.gymClass.name
                vm.timePresented.value = TimePeriodFormatter().getTimePeriod(from: session.startDate, durationMins: session.durationMins)
                vm.trainerName.value = "\(session.trainer.surname) \(session.trainer.forename.prefix(1))."
            }
            
            self.delegate?.reloadData()
        }
    }
    
    
    
    // MARK: - CollectionView related
    
    func getNumberOfSections() -> Int {
//        return 2
        return 1
    }
    
    func getNumberOfItems(for section: Int) -> Int {
        return scheduleCellViewModels.count
//        if section == 0 {
//            return 2
//        }
//
//        return 3
    }
    
    func getViewModel(for indexPath: IndexPath) -> ScheduleCellViewModelProtocol {
        return scheduleCellViewModels[indexPath.row]
    }
    
    func getTextForHeader(at section: Int) -> String {
        return "---time_header---"
    }
}

