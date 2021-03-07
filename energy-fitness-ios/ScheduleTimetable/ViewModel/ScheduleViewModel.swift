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
    
    private let dataRepository: DataRepository
    private let cellFactory: ScheduleCellVMFactoryProtocol
    private let scheduleOrganiser: ScheduleOrganiserProtocol
    
    private var organisedSessions = [OrganisedSession]()
    private var scheduleCellViewModels = Dictionary<IndexPath, ScheduleCellViewModelProtocol>()
    private lazy var dummyLoadingCellViewModel = ScheduleCellViewModel()
    
    
    // MARK: - Lifecycle
    init(
        dataRepository: DataRepository,
        cellFactory: ScheduleCellVMFactoryProtocol,
        scheduleOrganiser: ScheduleOrganiserProtocol
    ) {
        self.dataRepository = dataRepository
        self.cellFactory = cellFactory
        self.scheduleOrganiser = scheduleOrganiser
        
        isInitialContentLoading = true
        setForInitialLoadingCells()
        fetchGymClasses()
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    
    // MARK: - Animation handling
    func enableLoadingAnimation() {
        delegate?.reloadData()
    }
    
    private func setForInitialLoadingCells() {
        isInitialContentLoading = true
        let dummyVM = cellFactory.createScheduleCellViewModel()
        self.scheduleCellViewModels[IndexPath(row: 0, section: 0)] =  dummyVM
    }
    
    func fetchGymClasses() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dataRepository.getAllGymSessions { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let sessions):
                    print("Here")
                    self.organisedSessions = self.scheduleOrganiser.sort(sessions: sessions, by: .time)
                    self.showLoadedSessions()
                    
                case .failure(let error):
                    Log.exception(message: "Received error \(error.localizedDescription)", error)
                }
            }
//        }
    }
    
    
    private func showLoadedSessions() {
        self.scheduleCellViewModels.removeAll()
        
        for section in 0..<organisedSessions.count {
            for row in 0..<organisedSessions[section].sessions.count {
                
                let session = organisedSessions[section].sessions[row]
                let cellViewModel = cellFactory.createScheduleCellViewModel()
                scheduleCellViewModels[IndexPath(row: row, section: section)] = cellViewModel
                
                cellViewModel.gymClassName.value = session.gymClass.name
                cellViewModel.timePresented.value = TimePeriodFormatter().getTimePeriod(from: session.startDate, durationMins: session.durationMins)
                cellViewModel.trainerName.value = "\(session.trainer.surname) \(session.trainer.forename.prefix(1))."
            }
        }

        
        DispatchQueue.main.async { [weak self] in
            self?.isInitialContentLoading = false
            self?.delegate?.reloadData()
        }
        
        downloadImagesForTrainers(for: organisedSessions)
    }
    
    private func downloadImagesForTrainers(for sessions: [OrganisedSession]) {
        var imageCellVMDictionary = Dictionary<String, [ScheduleCellViewModelProtocol]>()
        
        for section in 0..<organisedSessions.count {
            for row in 0..<organisedSessions[section].sessions.count {
                let session = organisedSessions[section].sessions[row]
                
                if let imageUrl = session.trainer.photos.first?.small {
                    let cellViewModel = scheduleCellViewModels[IndexPath(row: row, section: section)]!
                    
                    if imageCellVMDictionary[imageUrl] == nil {
                        imageCellVMDictionary[imageUrl] = [cellViewModel]
                    } else {
                        imageCellVMDictionary[imageUrl]!.append(cellViewModel)
                    }
                }
            }
        }
        
        imageCellVMDictionary.keys.forEach { [weak self] imageDownloadName in
            self?.dataRepository.getTrainerImage(imageDownloadName, completion: { image in
                imageCellVMDictionary[imageDownloadName]?.forEach { cellViewModel in
                    cellViewModel.trainerImage.value = image
                }
            })
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
        print("--- section \(indexPath.section) row \(indexPath.row)")
        return isInitialContentLoading
                    ? dummyLoadingCellViewModel
                    : scheduleCellViewModels[indexPath]!
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

