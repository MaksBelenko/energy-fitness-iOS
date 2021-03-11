//
//  URLSessionAdapter.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation

enum NetworkError: Error {
    case decodingError(message: String)
    case nilResult(message: String)
}


class URLSessionAdapter: NetworkAdapterProtocol {
    
    // TODO: Put in DI properties below
    private let jsonDecoder: IJsonDecoderWrapper

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = false
        
        return URLSession(configuration: configuration)
    }()
    
    
    
    init(jsonDecoder: IJsonDecoderWrapper) {
        self.jsonDecoder = jsonDecoder
    }
    
    
    func request<T: Decodable>(_ urlRequest: URLRequest, returnType: T.Type, completion: @escaping (Result<T, APIError>) -> ()) -> URLSessionDataTask {
        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            let requestResult: Result<T, APIError>
            
            if let error = error {
                requestResult = .failure(.networkError(error))
            } else if let apiError = APIError.error(from: response) {
                requestResult = .failure(apiError)
            } else {
                
                do {
                    let decodedResult = try self?.jsonDecoder.decode(returnType, from: data!)

                    guard let result = decodedResult else {
                        throw NetworkError.nilResult(message: "Decoded result is nil, perhaps the class instance with jsonDecoder did deinit before the closure")
                    }
                    
                    requestResult = .success(result)
                    
                } catch let err as DecodingError {
                    requestResult = .failure(APIError.decodingError(err))
                } catch {
                    requestResult = .failure(.unhandledResponse)
                }
            }
            
            completion(requestResult)
        }
        
        task.resume()
        
        return task
    }
    
    func downloadImage(using urlRequest: URLRequest, completion: @escaping (Result<URL, APIError>) -> ()) -> URLSessionDownloadTask {
        let downloadTask = session.downloadTask(with: urlRequest) { downloadedFileUrl, response, error in
            let requestResult: Result<URL, APIError>
            
            if let error = error {
                requestResult = .failure(.networkError(error))
            } else if let apiError = APIError.error(from: response) {
                requestResult = .failure(apiError)
            } else {
                if let downloadedImageUrl = downloadedFileUrl {
                    requestResult = .success(downloadedImageUrl)
                } else {
                    requestResult = .failure(.unhandledResponse)
                }
            }
            
            completion(requestResult)
        }
        
        downloadTask.resume()
        
        return downloadTask
    }
}
