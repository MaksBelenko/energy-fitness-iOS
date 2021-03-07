//
//  GymClassDto.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation

struct GymClassDto: Decodable {
    let id: String
    let name: String
    let description: String
    let photos: [PhotoDto]
}

extension GymClassDto {
    static func ==(lhs: GymClassDto, rhs: GymClassDto) -> Bool {
        return lhs.id == rhs.id
    }
}
