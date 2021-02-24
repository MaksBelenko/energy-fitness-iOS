//
//  GymSession.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

struct GymSession: Decodable {
    let id: String
    let maxNumberOfPlaces: Int
    let bookedPlaces: Int
    let startDate: Date
    let durationMins: Int
    let gymClass: GymClass
    let trainer: Trainer
}
