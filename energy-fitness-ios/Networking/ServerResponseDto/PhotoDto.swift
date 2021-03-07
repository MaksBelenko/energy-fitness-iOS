//
//  Photo.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

struct PhotoDto: Decodable {
    let id: String
    let small: String
    let medium: String
    let large: String
}
