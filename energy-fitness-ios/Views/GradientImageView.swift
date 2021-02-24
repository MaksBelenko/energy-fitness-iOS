//
//  GradientImageView.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 18/02/2021.
//

import UIKit
import SwiftUI

class GradientImageView: UIView {

    private let gradientHeightProportion: CGFloat = 1/4
    
    private lazy var photoIV: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "general")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.clear.cgColor
        iv.layer.borderWidth = 0
        return iv
    }()
    
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.withAlphaComponent(0).cgColor, UIColor.energyBackgroundColor.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.shouldRasterize = true
        gradientLayer.frame = CGRect.zero
       return gradientLayer
    }()
    
    
    // MARK: - Lifecycle
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let viewWidth = self.frame.width
        let viewHeight = self.frame.height
        let gradientHeight = viewHeight * gradientHeightProportion
        // Offset of 1 is to remove the intersection of picture (looks like border)
        gradientLayer.frame = CGRect(x: -1,
                                     y: viewHeight - gradientHeight + 1,
                                     width: viewWidth + 2,
                                     height: gradientHeight)
    }
    
    
    
    // MARK: - UI Configuration
    private func configureUI() {
        addSubview(photoIV)
        photoIV.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        photoIV.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Picture set
    func setImage(to image: UIImage) {
        photoIV.image = image
//        photoIV.setNeedsDisplay()
    }
    
}

// MARK: - TraitCollection
extension GradientImageView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                gradientLayer.colors = [UIColor.clear.withAlphaComponent(0).cgColor, UIColor.energyBackgroundColor.cgColor]
            }
        }
    }
}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------------
struct GradientImageView_IntegratedController: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = GradientImageView()
        return view
    }
}

struct GradientImageView_PreviewView: View {
    var body: some View {
        GradientImageView_IntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct GradientImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GradientImageView_PreviewView()
                .previewLayout(.fixed(width: 375, height: 450))
                .preferredColorScheme(.light)
            
            GradientImageView_PreviewView()
                .previewLayout(.fixed(width: 375, height: 450))
                .preferredColorScheme(.dark)
        }
    }
}
