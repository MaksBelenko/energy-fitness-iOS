//
//  DarkenedImageView.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import UIKit

final class DarkenedImageView: UIImageView {

    /// Opacity of the black layer on top of image view
    var darkLevel: CGFloat = 0.4 {
        didSet {
            darkView.backgroundColor = UIColor.black.withAlphaComponent(darkLevel)
        }
    }
    
    private lazy var darkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(darkLevel)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .scaleAspectFill
        
        addSubview(darkView)
        darkView.contain(in: self)
    }
    
    convenience init(image: UIImage) {
        self.init(frame: .zero)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
