//
//  BasicRequestBuilder.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 05/03/2021.
//

import Foundation

struct BasicRequestBuilder: RequestBuilderProtocol {
    var method: HTTPMethod
    var baseURL: URL
    var path: String
    var params: [URLQueryItem]?
    var headers: [String: String] = [:]
    
    public static func basic(method: HTTPMethod = .get, baseURL: URL, path: String, params: [URLQueryItem]? = nil, completion: @escaping (Result<Data, APIError>) -> Void) -> Request {
        let builder = BasicRequestBuilder(method: method, baseURL: baseURL, path: path, params: params)
        return Request(builder: builder, completion: completion)
    }
}
