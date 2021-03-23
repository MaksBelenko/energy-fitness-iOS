//
//  TokensDto.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 22/03/2021.
//

import Foundation

struct TokensDto: Decodable {
    let accessToken: String
    let refreshToken: String
}
