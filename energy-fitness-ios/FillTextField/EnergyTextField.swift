//
//  EnergyTextField.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 21/03/2021.
//

import UIKit

final class EnergyTextField: FillTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .raleway(ofSize: 13)
        backgroundColor = .energyTextFieldBackground
        textColor = .energyTextFieldTextColour
        tintColor = .energyTextFieldTextColour
        placeholderColor = .energyTFPlaceholderColour
        layer.cornerRadius = 5
        smallPlaceholderFont = .raleway(ofSize: 11)
        smallPlaceholderColor = .energyTFPlaceholderColour
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
