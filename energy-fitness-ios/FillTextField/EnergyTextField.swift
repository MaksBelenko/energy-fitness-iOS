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
        
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        font = .raleway(ofSize: 14)
        backgroundColor = .energyTextFieldBackground
        textColor = .energyTextFieldTextColour
        tintColor = .energyTextFieldTextColour
        layer.cornerRadius = 5
        placeholderColor = .energyTFPlaceholderColour
        
        smallPlaceholderFont = .raleway(ofSize: 12)
        smallPlaceholderColor = .energyTFPlaceholderColour
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
