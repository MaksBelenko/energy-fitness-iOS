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
    
    
    func request<T: Decodable>(_ urlRequest: URLRequest, returnType: T.Type, completion: @escaping (Result<T, APIError>) -> ()) {
        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            let requestResult: Result<T, APIError>
            
            if let error = error {
                requestResult = .failure(.networkError(error))
            } else if let apiError = APIError.error(from: response) {
                requestResult = .failure(apiError)
            } else {
                
                do {
                    guard let decodedResult = try self?.jsonDecoder.decode(returnType, from: data!) else {
                        throw NetworkError.decodingError(message: "Could not decode message for data using type \(String(describing: T.self))")
                    }
                    
                    requestResult = .success(decodedResult)
                } catch let err as DecodingError {
                    requestResult = .failure(APIError.decodingError(err))
                } catch {
                    requestResult = .failure(.unhandledResponse)
                }
            }
            
            completion(requestResult)
        }
        
        task.resume()
    }
    
//    func request<T: Decodable>(method: HttpNetworkMethod, apiRoute: ApiRoute, returnType: T.Type, completion: @escaping (T) -> ()) throws {
//        let urlString = networkConstants.baseUrl + apiRoute.rawValue
//
//        let url = URL(string: urlString)!
//
//        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
//        request.httpMethod = method.rawValue
//
//        let task = session.dataTask(with: request) { [weak self] data, response, error in
//
//            if let receivedError = error {
//                Log.exception(message: receivedError.localizedDescription, "")
//            }
//
////            dump(data!
//            do {
//                let requestResult = try self?.jsonDecoder.decode(returnType, from: data!)
//
//                guard let result = requestResult else {
//                    throw NetworkError.decodingError(message: "Could not decode message for data using type \(String(describing: T.self))")
//                }
//
//                completion(result)
//            } catch {
//                print("Error decoding")
//            }
//        }
//
//        task.resume()
//    }
    
    
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
