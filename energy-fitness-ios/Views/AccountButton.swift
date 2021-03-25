//
//  AccountButton.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import UIKit.UIButton

class AccountButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(question: String, actionName: String, font: UIFont = .boldSystemFont(ofSize: 16)) {
        let attributedTitle = NSMutableAttributedString(string: "\(question) ",attributes:
                                [NSAttributedString.Key.font : font,
                                 NSAttributedString.Key.foregroundColor : UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: actionName, attributes:
                                [NSAttributedString.Key.font : font,
                                 NSAttributedString.Key.foregroundColor : UIColor.systemRed]))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
