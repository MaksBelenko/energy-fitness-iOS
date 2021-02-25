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
    
    func enableLoadingAnimation()
    func getNumberOfSections() -> Int
    func getNumberOfItems(for section: Int) -> Int
    func getTextForHeader(at section: Int) -> String
}

class ScheduleViewModel: ScheduleViewModelProtocol {
    
    weak var delegate: ScheduleViewModelDelegate?
    
    private let networkService: NetworkServiceProtocol
    
    private var gymSessions = [GymSession]()
    
    var isTextLoading = PassthroughSubject<Bool, Never>()
    
    
    // MARK: - Lifecycle
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
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
    }
    
    
    
    // MARK: - CollectionView related
    
    func getNumberOfSections() -> Int {
        return 2
    }
    
    func getNumberOfItems(for section: Int) -> Int {
//            return gymSessions.count
        if section == 0 {
            return 2
        }
        
        return 3
    }
    
    func getTextForHeader(at section: Int) -> String {
        return "---time_header---"
    }
}

