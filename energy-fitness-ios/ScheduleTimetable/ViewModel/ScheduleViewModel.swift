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

class ScheduleViewModel {
    
    weak var delegate: ScheduleViewModelDelegate?
    private let networkService = NetworkService()
    
    private var reuseIdentifier: String!
    
    private let cellReuseIdentifier: String
    private let shimmerReuseIdentifier: String
    
//    private var gymClasses = [GymClass]()
    private var gymSessions = [GymSession]()
    
    
    init(cellReuseIdentifier: String, shimmerReuseIdentifier: String) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.shimmerReuseIdentifier = shimmerReuseIdentifier
        
        startLoadingAnimation()
        fetchGymClasses()
    }
    
    private func startLoadingAnimation() {
        reuseIdentifier = shimmerReuseIdentifier
        delegate?.reloadData()
    }
    
    private func fetchGymClasses() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.networkService.getAllSessions { [weak self] sessions in
                guard let self = self else { return }
//                self.gymSessions = sessions
                self.reuseIdentifier = self.cellReuseIdentifier
                DispatchQueue.main.async {
                    self.delegate?.reloadData()
                }
            }
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

