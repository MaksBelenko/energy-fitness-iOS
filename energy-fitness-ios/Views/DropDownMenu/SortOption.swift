//
//  SortOption.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 12/03/2021.
//

import Foundation

struct SortOption<T: Hashable>: Hashable {
    let key: T
    let value: String
}
