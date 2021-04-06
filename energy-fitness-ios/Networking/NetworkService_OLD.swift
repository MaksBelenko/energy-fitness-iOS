//
//  NetworkService.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 20/02/2021.
//

import UIKit.UIImage

protocol NetworkServiceProtocol {
    func getAllSessions(completion: @escaping (Result<[GymSessionDto], APIError> ) -> ())
    func downloadImage(for imageRouteType: ImageDownloadRoute, imageName: String, completion: @escaping (UIImage) -> ())
}

class NetworkService123: NetworkServiceProtocol {
    
    private var networkOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        return operationQueue
    }()
    
    private let networkFetchOperationFactory: NetworkFetchOperationFactoryProtocol
    private let requestBuilder: RequestBuilderProtocol
    private let imageDownloadOperationFactory: ImageDownloadOperationFactory
    
    private lazy var getAllGymClassesRequest: URLRequest = {
        let request = requestBuilder
                        .withBaseURL(URL(string: "http://localhost:3000/api")!)
                        .withPath(ApiRoute.gymSessions.rawValue)
                        .build()
        return request
    }()
    
    
    // MARK: - Lifecycle
    init(
        requestBuilder: RequestBuilderProtocol,
        networkFetchOperationFactory: NetworkFetchOperationFactoryProtocol,
        imageDownloadOperationFactory: ImageDownloadOperationFactory
    ) {
        self.requestBuilder = requestBuilder
        self.networkFetchOperationFactory = networkFetchOperationFactory
        self.imageDownloadOperationFactory = imageDownloadOperationFactory
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    
    func getAllSessions(completion: @escaping (Result<[GymSessionDto], APIError> ) -> ()) {
        let request = getAllGymClassesRequest

        let fetchGymClassesOperation = networkFetchOperationFactory.create(urlRequest: request, returnType: [GymSessionDto].self)
        fetchGymClassesOperation.onResult = { result in
            switch result {
            case .success(let gymSessions):
                completion(.success(gymSessions))

            case .failure(let error):
                Log.exception(message: "Error \(error.localizedDescription) appeared when fetching", error)
            }
        }

        networkOperationQueue.addOperation(fetchGymClassesOperation)
    }
    
    
    func downloadImage(for imageRouteType: ImageDownloadRoute, imageName: String, completion: @escaping (UIImage) -> ()) {
        let path = imageRouteType.rawValue + "/" + imageName
        
        let request = requestBuilder
            .withBaseURL(URL(string: "http://localhost:3000/api")!)
                        .withPath(path)
                        .build()
        
        let imageDownloadOperation = imageDownloadOperationFactory.create(urlRequest: request)
        
        imageDownloadOperation.onResult = { result in
            switch result {
            case .success(let image):
                completion(image)
        
            case .failure(let error):
                Log.exception(message: "Error \(error.localizedDescription) appeared when fetching", error)
            }
        }
        
        networkOperationQueue.addOperation(imageDownloadOperation)
    }

    
    
    // MARK: - Helper methods
    
    private func handle(error: Error) {
        
    }
}
