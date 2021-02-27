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
    
    private var gymSessions = [GymSession]()
    private var scheduleCellViewModels = [ScheduleCellViewModel]()
    
    var isTextLoading = PassthroughSubject<Bool, Never>()
    
    
    // MARK: - Lifecycle
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        
        fetchGymClasses()
    }
    
    deinit {
        Log.logDeinit(String(describing: self))
    }
    
    
    
    // MARK: - Animation handling
    func enableLoadingAnimation() {
        delegate?.reloadData()
    }
    
    func fetchGymClasses() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.networkService.getAllSessions { [weak self] sessions in
//                guard let self = self else { return }
////                self.gymSessions = sessions
//                self.reuseIdentifier = self.cellReuseIdentifier
//                DispatchQueue.main.async {
//                    self.delegate?.reloadData()
//                }
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.scheduleCellViewModels = [
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
                ScheduleCellViewModel(),
            ]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [unowned self] in
                self.scheduleCellViewModels.forEach { $0.setTextLoading(to: false) }
            }
//        }
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

