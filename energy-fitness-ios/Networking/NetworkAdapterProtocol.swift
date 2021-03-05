//
//  NetworkAdapter.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//
import Foundation

protocol NetworkAdapterProtocol {
//    func request<T: Decodable>(method: HttpNetworkMethod, apiRoute: ApiRoute, returnType: T.Type, completion: @escaping (T) -> ()) throws
    func request<T: Decodable>(_ urlRequest: URLRequest, returnType: T.Type, completion: @escaping (Result<T, APIError>) -> ()) throws
}
