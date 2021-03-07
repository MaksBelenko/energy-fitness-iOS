//
//  ApiFetchOperation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 04/03/2021.
//

import Foundation

class ApiFetchOperation<T: Decodable>: ChainedAsyncResultOperation<URLRequest, T, ApiFetchOperation.Error> {
    
    public enum Error: Swift.Error {
        case canceled
        case requestFailed(APIError)
        case networkAdapterNotInjected
        case missingInputURL
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }

    var networkAdapter: NetworkAdapterProtocol?
    private var dataTask: URLSessionTask?
    
    
    override func main() {
        guard let input = input else { return finish(with: .failure(.missingInputURL)) }
        guard let networkAdapter = networkAdapter else { return finish(with: .failure(.networkAdapterNotInjected))}
        
        dataTask = networkAdapter.request(input, returnType: T.self, completion: { [weak self] result in
            switch result {
               case .success(let gymSessions):
                    self?.finish(with: .success(gymSessions))

               case .failure(let error):
                    Log.exception(message: "Received error \(error.localizedDescription) when fetching ", error)
                    self?.finish(with: .failure(.requestFailed(error)))
            }
        })
    }
    
    override final public func cancel() {
        dataTask?.cancel()
        cancel(with: .canceled)
    }
}
