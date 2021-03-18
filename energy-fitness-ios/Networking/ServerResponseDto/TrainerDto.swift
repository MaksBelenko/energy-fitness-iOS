//
//  Trainer.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

struct TrainerDto: Decodable {
    let id: String
    let forename: String
    let surname: String
    let description: String
    let type: String //TrainerType
    let photos: [PhotoDto]
}

extension TrainerDto {
    static func ==(lhs: TrainerDto, rhs: TrainerDto) -> Bool {
        return lhs.id == rhs.id
    }
}

extension TrainerDto {
    func getInitials() -> String {
        return (forename.first?.uppercased() ?? "-") + (surname.first?.uppercased() ?? "-")
    }
    
    func getSurnameWithFirstNameLetter() -> String {
        return "\(surname) \(forename.first?.uppercased() ?? "")."
    }
}
