//
//  APIError.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

public enum APIError: Error {
    /// Encoding issue when trying to send data.
    case encodingError(String?)
    // if our response is not an HTTPURLResponse
    case unknownResponse
    // The request could not be made (due to a timeout, missing connectivity, offline, etc).
    // The associated value provides the underlying reason.
    case networkError(Error)
    // The request was made but the response indicated the request was invalid.
    // This can be for missing params, missing authentication, etc. Associated
    // value provides the HTTP Status Code. (HTTP 4xx)
//    case unauthorised //401
//    case forbidden    //403
//    case notFound     //404
    case requestError(Int)
    // The request was made but the response indicated the server had an error.
    // Associated value provides the HTTP Status Code. (HTTP 5xx)
    case serverError(Int)
    // The response format could not be decoded into the  expected type
    case decodingError(DecodingError)
    // catch all for something we should be handling!
    case unhandledResponse
}

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (let .requestError(lhsStatus), let .requestError(rhsStatus)):
            return lhsStatus == rhsStatus
        case (let .serverError(lhsStatus), let .serverError(rhsStatus)):
            return lhsStatus == rhsStatus
        default:
            return false
        }
    }
}

extension APIError {
    static func error(from response: URLResponse?) -> APIError? {
        guard let http = response as? HTTPURLResponse else {
            return .unknownResponse
        }
        
        switch http.statusCode {
            case 200...299:  return nil
//            case 400: return .requestError(http.statusCode)
//            case 401: return .unauthorised
//            case 402: return .requestError(http.statusCode)
//            case 403: return .forbidden
//            case 404: return .notFound
//            case 405...499: return .requestError(http.statusCode)
            case 400...499: return .requestError(http.statusCode)
            case 500...599: return .serverError(http.statusCode)
            default: return .unhandledResponse
        }
    }
}
