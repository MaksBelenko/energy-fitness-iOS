//
//  ApiFetchOperationFactory.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 06/03/2021.
//

import Foundation

protocol ApiFetchOperationFactoryProtocol {
    func create<T: Decodable>(urlRequest: URLRequest?, returnType: T.Type) -> ApiFetchOperation<T>
}

class ApiFetchOperationFactory: ApiFetchOperationFactoryProtocol {
    
    private let networkAdapter: NetworkAdapterProtocol
    
    init(networkAdapter: NetworkAdapterProtocol) {
        self.networkAdapter = networkAdapter
    }
    
    func create<T: Decodable>(urlRequest: URLRequest? = nil, returnType: T.Type) -> ApiFetchOperation<T> {
        let operation = ApiFetchOperation<T>(input: urlRequest) // no need for nil check as it will be resilved by updateDependancies
        operation.networkAdapter = networkAdapter
        return operation
    }
}
