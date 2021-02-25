//
//  NetworkAdapter.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

protocol NetworkAdapterProtocol {
    func request<T: Decodable>(method: HttpNetworkMethod, apiRoute: ApiRoute, returnType: T.Type, completion: @escaping (T) -> ()) throws
}
