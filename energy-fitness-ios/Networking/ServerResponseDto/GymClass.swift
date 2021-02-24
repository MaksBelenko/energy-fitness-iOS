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
