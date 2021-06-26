//
//  PaddedButton.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/06/2021.
//

import UIKit

final class PaddedButton: UIButton {
    private let insets: UIEdgeInsets
    
    var textColour: UIColor? {
        didSet { setTitleColor(textColour, for: .normal) }
    }
    
    var text: String? {
        didSet { setTitle(text, for: .normal) }
    }
    
    var font: UIFont? {
        didSet { titleLabel?.font = font }
    }
    
    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }
    
    convenience init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        self.init(insets: insets)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}
