//
//  GymSession.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

struct GymSessionDto: Decodable, Hashable {
    let id: String
    let maxNumberOfPlaces: Int
    let bookedPlaces: Int
    let startDate: Date
    let durationMins: Int
    let gymClass: GymClassDto
    let trainer: TrainerDto
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GymSessionDto, rhs: GymSessionDto) -> Bool {
        return lhs.id == rhs.id
    }
}
