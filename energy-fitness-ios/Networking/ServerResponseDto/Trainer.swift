//
//  Trainer.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

struct Trainer: Decodable {
    let id: String
    let forename: String
    let surname: String
    let description: String
    let type: String //TrainerType
    let photos: [Photo]
}

extension Trainer {
    static func ==(lhs: Trainer, rhs: Trainer) -> Bool {
        return lhs.id == rhs.id
    }
}
