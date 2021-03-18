//
//  GradientImageView.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 18/02/2021.
//

import UIKit
import SwiftUI

class GradientImageView: UIView {

    var image: UIImage? {
        didSet {
            loadingIndicator.isAnimating = false
            self.alpha = 0
            self.photoIV.image = self.image
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1
            }
        }
    }
    
    private let gradientHeightProportion: CGFloat = 1/2
    
    private lazy var loadingIndicator: LoadingIndicatorView = {
        let indicator = LoadingIndicatorView()
        return indicator
    }()
    
    private lazy var photoIV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.clear.cgColor
        iv.layer.borderWidth = 0
        return iv
    }()
    
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.energyBackgroundColor.withAlphaComponent(0).cgColor, UIColor.energyBackgroundColor.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.shouldRasterize = true
        gradientLayer.frame = CGRect.zero
        gradientLayer.startPoint = CGPoint(x: 0.5, y: gradientHeightProportion)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
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
        
        let frame = photoIV.frame
        let layerFrame = CGRect(origin: CGPoint(x: frame.origin.x - 1, y: frame.origin.y - 1),
                                size: CGSize(width: frame.width + 2, height: frame.height + 2))
        gradientLayer.frame = layerFrame
    }
    
    
    // MARK: - UI Configuration
    private func configureUI() {
        addSubview(photoIV)
        photoIV.contain(in: self)
        photoIV.layer.addSublayer(gradientLayer)
        
        addSubview(loadingIndicator)
        loadingIndicator.centerX(withView: self)
        loadingIndicator.centerY(withView: self)
        loadingIndicator.anchor(width: 30, height: 30)
        loadingIndicator.isAnimating = true
    }
}

// MARK: - TraitCollection
extension GradientImageView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                gradientLayer.colors = [UIColor.energyBackgroundColor.withAlphaComponent(0).cgColor, UIColor.energyBackgroundColor.cgColor]
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
