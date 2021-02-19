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
//    let sessions: GymSessionDto[]
//    let photos: PhotoDto[]
}
