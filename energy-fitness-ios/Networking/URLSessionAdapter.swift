//
//  URLSessionAdapter.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation

class URLSessionAdapter: NetworkAdapterProtocol {
    
    // TODO: Put in DI properties below
    private let jsonDecoder: IJsonDecoderWrapper = JSONDecoderWrapper()
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = false

        return URLSession(configuration: configuration)
    }()
    
    
    
    func request<T: Decodable>(url: URL, _ returnType: T.Type) {
        let url = URL(string: "http://localhost:3000/api/gym-classes/")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        
//        session
//                    .request(url: request)
//                    .decoded()
//                    .saved(in: database)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            
//            debugPrint("Data: \(data)")
//            debugPrint("Response: \(response)")
            
            do {
                let gymClass = try self?.jsonDecoder.decode(returnType, from: data!)
                debugPrint(gymClass)
            } catch {
                print("Error decoding")
            }
            
            
        }
        
        task.resume()
    }
}
