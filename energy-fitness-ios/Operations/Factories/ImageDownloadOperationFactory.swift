//
//  ImageDownloadOperationFactory.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 06/03/2021.
//

import Foundation

class ImageDownloadOperationFactory {
    
    private let networkAdapter: NetworkAdapterProtocol
    
    init(networkAdapter: NetworkAdapterProtocol) {
        self.networkAdapter = networkAdapter
    }
    
    func create(urlRequest: URLRequest? = nil) -> ImageDownloadOperation {
        let operation = ImageDownloadOperation(input: urlRequest) // no need for nil check as it will be resilved by updateDependancies
        operation.networkAdapter = networkAdapter
        return operation
    }
}
