//
//  Photo.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

struct PhotoDto: Decodable {
    let id: String
    let small: String  // 100px
    let medium: String // 500px
    let large: String  // 1024px
}

extension PhotoDto: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: PhotoDto, rhs: PhotoDto) -> Bool {
        return lhs.id == rhs.id
    }
}
