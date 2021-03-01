//
//  ImageViewWithShimmer.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 01/03/2021.
//

import UIKit.UIView


/// A generic class over any UIView (UILabel, UIImageView etc)
/// used to abstract and add Shimmer view on top of the UIView
///
/// You need to configureShimmer(gradientFrame:) to init the shimmer.
/// The underlying UIView/UILabel/UIImageView etc will be available in
/// "view" property
class Shimmered<T> : UIView where T : UIView {
    
    var view = T()
    var shimmer: ShimmerView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        view.contain(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureShimmer(gradientFrame: CGRect, width: CGFloat? = nil, topOffset: CGFloat = 0) {
        shimmer = self.addShimmerView(gradientFrame: gradientFrame, width: width, topOffset: topOffset)
    }
    
    private func addShimmerView(gradientFrame: CGRect, width: CGFloat? = nil, topOffset: CGFloat = 0) -> ShimmerView {
        let shimmerView = ShimmerView(gradientColour: .energyShimmerUnder, gradientFrame: gradientFrame)
        shimmerView.backgroundColor = .energyShimmer
        
        self.addSubview(shimmerView)
        shimmerView.anchor(top: self.topAnchor, paddingTop: topOffset,
                           leading: self.leadingAnchor,
                           bottom: self.bottomAnchor)
        
        if let width = width {
            shimmerView.anchor(width: width)
        } else {
            shimmerView.anchor(trailing: self.trailingAnchor)
        }
        
        return shimmerView
    }
}
