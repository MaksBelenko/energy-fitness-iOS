//
//  ScheduleViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

protocol ScheduleViewModelDelegate: AnyObject {
    func reloadData()
}

protocol ScheduleViewModelProtocol {
    var delegate: ScheduleViewModelDelegate? { get set }
    var cellReuseIdentifier: String! { get set }
    var shimmerReuseIdentifier: String! { get set }
    
    func enableLoadingAnimation()
    func getCurrentReuseIdentifier() -> String
    func getNumberOfSections() -> Int
    func getNumberOfItems(for section: Int) -> Int
    func getTextForHeader(at section: Int) -> String
}

class ScheduleViewModel: ScheduleViewModelProtocol {
    
    weak var delegate: ScheduleViewModelDelegate?
    
    private let networkService: NetworkServiceProtocol
    
    private var reuseIdentifier: String!
    
    var cellReuseIdentifier: String!
    var shimmerReuseIdentifier: String!
    
//    private var gymClasses = [GymClass]()
    private var gymSessions = [GymSession]()
    
    
    // MARK: - Lifecycle
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    deinit {
        Log.logDeinit(String(describing: self))
    }
    
    
    
    func enableLoadingAnimation() {
        reuseIdentifier = shimmerReuseIdentifier
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
    
    func getCurrentReuseIdentifier() -> String {
        return reuseIdentifier
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfItems(for section: Int) -> Int {
        if reuseIdentifier == cellReuseIdentifier {
            return gymSessions.count
        }
        
        return 8
    }
    
    func getTextForHeader(at section: Int) -> String {
        return "---time_header---"
    }
}

