//
//  ShimmerScheduleCell.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 08/02/2021.
//

import UIKit
import SwiftUI

class ShimmerScheduleCell: UICollectionViewCell, ReuseIdentifiable {

    private let rectCornerRadius: CGFloat = 3
    
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
        let classNameBox = ShimmerView(gradientColour: .energyShimmerUnder, gradientFrame: self.bounds)
        classNameBox.backgroundColor = .energyShimmer
        view.addSubview(classNameBox)
        classNameBox.anchor(top: view.topAnchor, paddingTop: 10,
                            leading: view.leadingAnchor, paddingLeading: 19,
                            width: 166, height: 15)
        
        let timeBox = ShimmerView(gradientColour: .energyShimmerUnder, gradientFrame: self.bounds)
        timeBox.backgroundColor = .energyShimmer
        view.addSubview(timeBox)
        timeBox.anchor(top: classNameBox.bottomAnchor, paddingTop: 8,
                       leading: classNameBox.leadingAnchor,
                       width: 127, height: 13)

        let trainerImageBox = ShimmerView(gradientColour: .energyShimmerUnder, gradientFrame: self.bounds)
        trainerImageBox.backgroundColor = .energyShimmer
        view.addSubview(trainerImageBox)
        trainerImageBox.anchor(top: timeBox.bottomAnchor, paddingTop: 9,
                               leading: classNameBox.leadingAnchor,
                               width: 27, height: 27)

        let trainerNameBox = ShimmerView(gradientColour: .energyShimmerUnder, gradientFrame: self.bounds)
        trainerNameBox.backgroundColor = .energyShimmer
        view.addSubview(trainerNameBox)
        trainerNameBox.centerY(withView: trainerImageBox)
        trainerNameBox.anchor(leading: trainerImageBox.trailingAnchor, paddingLeading: 10,
                              width: 93, height: 13)

        view.addSubview(chevronArrow)
        chevronArrow.anchor(trailing: view.trailingAnchor, paddingTrailing: 20,
                            width: 15, height: 20)
        chevronArrow.centerY(withView: view)

        layoutIfNeeded()
        trainerImageBox.layer.cornerRadius = trainerImageBox.frame.height / 2
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
