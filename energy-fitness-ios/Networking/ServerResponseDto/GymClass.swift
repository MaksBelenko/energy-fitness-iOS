//
//  GymClassDto.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 10/02/2021.
//

import Foundation

struct GymClass: Decodable {
    let id: String
    let name: String
    let description: String
    let photos: [Photo]
}

extension GymClass {
    static func ==(lhs: GymClass, rhs: GymClass) -> Bool {
        return lhs.id == rhs.id
    }
}
