//
//  Repository.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 06/03/2021.
//

import UIKit.UIImage

class DataRepository {
    
    enum DataError: Error {
        case failed
    }
    
    private let networkService: NetworkServiceProtocol
    
    
    // MARK: - Lifecycle
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    // MARK: - Public methods
    
    func getAllGymSessions(completion: @escaping (Result<[GymSessionDto], DataError>) -> ()) {
            self.networkService.getAllSessions { gymSessions in
                completion(.success(gymSessions))
            }
    }
    
    func getTrainerImage(_ imageName: String, completion: @escaping (UIImage) -> ()) {
            self.networkService.downloadImage(for: .trainer, imageName: imageName, completion: completion)
    }
}
