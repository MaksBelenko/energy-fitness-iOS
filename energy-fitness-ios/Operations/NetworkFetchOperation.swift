//
//  ApiFetchOperation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 04/03/2021.
//

import Foundation

class NetworkFetchOperation<T: Decodable>: ChainedAsyncResultOperation<URLRequest, T, NetworkFetchOperation.Error> {
    
    public enum Error: Swift.Error {
        case canceled
        case requestFailed(APIError)
        case missingInputURL
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }

    var networkAdapter: NetworkAdapterProtocol?
    private var dataTask: URLSessionTask?
    
    
    override func main() {
        guard let input = input else { return finish(with: .failure(.missingInputURL)) }
        guard let networkAdapter = networkAdapter else { fatalError("NetworkAdapter Not Injected") }
        
        dataTask = networkAdapter.request(input, returnType: T.self, completion: { [weak self] result in
            switch result {
               case .success(let gymSessions):
                    self?.finish(with: .success(gymSessions))

               case .failure(let error):
                    self?.finish(with: .failure(.requestFailed(error)))
            }
        })
    }
    
    override final public func cancel() {
        dataTask?.cancel()
        cancel(with: .canceled)
    }
}
