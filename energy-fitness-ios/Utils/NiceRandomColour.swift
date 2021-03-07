//
//  NiceRandomColour.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 07/03/2021.
//

import UIKit.UIColor
import RandomColor

class NiceRandomColour {
    
    func generate() -> UIColor {
        let colour = randomColor(hue: .random, luminosity: .dark)
        return colour
    }
}
