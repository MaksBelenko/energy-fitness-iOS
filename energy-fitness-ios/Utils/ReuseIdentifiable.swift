//
//  ReuseIdentifiable.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//


// MARK: - Reuse Identifiable
protocol ReuseIdentifiable {
    static func reuseIdentifier() -> String
}

extension ReuseIdentifiable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
