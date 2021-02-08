//
//  ShimmerScheduleCell.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 08/02/2021.
//

import UIKit
import SwiftUI

class ShimmerScheduleCell: UICollectionViewCell, ReuseIdentifiable {
    
    private var shimmerAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.5
        return animation
    }()
    
    private var internalView: UIView = {
        let view = UIView()
        view.backgroundColor = .energyCellColour
        view.layer.cornerRadius = 16
        view.layer.applyShadow(color: .black, alpha: 0.16, x: 5, y: 5, blur: 10)
        return view
    }()
    
    private var chevronArrow: UIImageView = {
        let iv = UIImageView()
        let image: UIImage = #imageLiteral(resourceName: "chevron").withTintColor(.energyDateDarkened)
        iv.image = image
        return iv
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .clear
        configureCellUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure UI
    private func configureCellUI() {
        addSubview(internalView)
        internalView.anchor(top: topAnchor,
                            leading: leadingAnchor, paddingLeading: 10,
                            bottom: bottomAnchor, paddingBottom: 10,
                            trailing: trailingAnchor, paddingTrailing: 10)
        
        configureElements(in: internalView)
    }
    
    private func configureElements(in view: UIView) {
        let classNameBox = createUnderView()
        view.addSubview(classNameBox)
        classNameBox.anchor(top: view.topAnchor, paddingTop: 10,
                            leading: view.leadingAnchor, paddingLeading: 19,
                            width: 166, height: 15)
        
        let timeBox = createUnderView()
        view.addSubview(timeBox)
        timeBox.anchor(top: classNameBox.bottomAnchor, paddingTop: 8,
                       leading: classNameBox.leadingAnchor,
                       width: 127, height: 13)

        let trainerImageBox = createUnderView()
        view.addSubview(trainerImageBox)
        trainerImageBox.anchor(top: timeBox.bottomAnchor, paddingTop: 9,
                               leading: classNameBox.leadingAnchor,
                               width: 27, height: 27)

        let trainerNameBox = createUnderView()
        view.addSubview(trainerNameBox)
        trainerNameBox.centerY(withView: trainerImageBox)
        trainerNameBox.anchor(leading: trainerImageBox.trailingAnchor, paddingLeading: 10,
                              width: 93, height: 13)

        layoutIfNeeded()
        trainerImageBox.layer.cornerRadius = trainerImageBox.frame.height / 2

        view.addSubview(chevronArrow)
        chevronArrow.anchor(trailing: view.trailingAnchor, paddingTrailing: 20,
                            width: 15, height: 20)
        chevronArrow.centerY(withView: view)
        
        
        addTopBox(for: classNameBox)
        addTopBox(for: timeBox)
        addTopBox(for: trainerImageBox)
        addTopBox(for: trainerNameBox)
    }
    
    private func createUnderView() -> UIView {
        let view = UIView()
        view.backgroundColor = .energyShimmer
        return view
    }
    
    //MARK: - Helpers
    
    private func addTopBox(for bottomView: UIView) {
        let view = UIView()
        view.backgroundColor = .energyShimmerUnder
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        view.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: bottomView.widthAnchor).isActive = true

        addShimmerMask(to: view)
    }


    private func addShimmerMask(to view: UIView) {
        let gradLayer = createGradientLayer()
        view.layer.mask = gradLayer
        gradLayer.add(shimmerAnimation, forKey: shimmerAnimation.keyPath)
    }
    
    
    func createGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.energyShimmerUnder.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }

}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct ShimmerScheduleCell_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        return ShimmerScheduleCell()
    }
}

struct ShimmerScheduleCell_PreviewView: View {
    var body: some View {
        ShimmerScheduleCell_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct ShimmerScheduleCell_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            ShimmerScheduleCell_PreviewView()
                .previewLayout(.fixed(width: 346, height: 100))
                .preferredColorScheme(.light)
        
            ShimmerScheduleCell_PreviewView()
                .previewLayout(.fixed(width: 346, height: 100))
                .preferredColorScheme(.dark)
        }
    }
}
