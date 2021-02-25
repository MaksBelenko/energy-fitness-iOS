//
//  URLSessionAdapter.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation

enum NetworkError: Error {
    case decodingError(message: String)
}


class URLSessionAdapter: NetworkAdapterProtocol {
    
    // TODO: Put in DI properties below
    private let networkConstants: NetworkConstants
    private let jsonDecoder: IJsonDecoderWrapper

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = false
        
        return URLSession(configuration: configuration)
    }()
    
    
    
    init(networkConstants: NetworkConstants, jsonDecoder: IJsonDecoderWrapper) {
        self.networkConstants = networkConstants
        self.jsonDecoder = jsonDecoder
    }
    
    
    func request<T: Decodable>(method: HttpNetworkMethod, apiRoute: ApiRoute, returnType: T.Type, completion: @escaping (T) -> ()) throws {
        let urlString = networkConstants.baseUrl + apiRoute.rawValue
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
//            dump(data!
            do {
                let requestResult = try self?.jsonDecoder.decode(returnType, from: data!)
                
                guard let result = requestResult else {
                    throw NetworkError.decodingError(message: "Could not decode message for data using type \(String(describing: T.self))")
                }
                
                completion(result)
            } catch {
                print("Error decoding")
            }
        }
        
        task.resume()
    }
    
    
    func getOne<T: Decodable>(apiRoute: ApiRoute, itemId: String, returnType: T.Type, completion: @escaping (T) -> ()) {
        let urlString = networkConstants.baseUrl + apiRoute.rawValue + "/" + itemId
        
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            
            do {
                let requestResult = try self?.jsonDecoder.decode(returnType, from: data!)
                
                guard let result = requestResult else {
                    throw NetworkError.decodingError(message: "Could not decode message for data from \(String(describing: T.self))")
                }
                
                completion(result)
            } catch {
                print("Error decoding")
            }
        }
        
        task.resume()
    }
}
