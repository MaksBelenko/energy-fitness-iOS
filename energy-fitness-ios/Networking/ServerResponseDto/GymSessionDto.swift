//
//  GymSession.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

struct GymSessionDto: Decodable {
    let id: String
    let maxNumberOfPlaces: Int
    let bookedPlaces: Int
    let startDate: Date
    let durationMins: Int
    let gymClass: GymClassDto
    let trainer: TrainerDto
}
