//
//  ScheduleCollectionViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit
import SwiftUI

class ClassesScheduleView: UIView {
    
    private var reuseIdentifier: String!
    private let pressAnimation = PressAnimation()
    
    lazy var scheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.energyContainerColor.cgColor, UIColor.white.withAlphaComponent(0).cgColor]//Colors you want to add
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.shouldRasterize = true
        gradientLayer.frame = CGRect.zero
       return gradientLayer
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scheduleCollectionView)
        scheduleCollectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        reuseIdentifier = ScheduleCell.reuseIdentifier()
        scheduleCollectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
//    private func registerCell<T: ScheduleCellProtocol>(type: T) {
//        reuseIdentifier = T.reuseIdentifier()
//        scheduleCollectionView.register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
//    }
    
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 10)
    }
}

// MARK: - UICollectionViewDataSource
extension ClassesScheduleView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.cornerRadius(16)
        cell.applyShadow(color: .black, alpha: 0.16, x: 5, y: 5, blur: 10)
        
        return cell
    }
    
//    colle
    

}

extension ClassesScheduleView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        return CGSize(width: width - 30, height: 90)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
}

// MARK: - UICollectionViewDelegate
extension ClassesScheduleView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
//        UIView.animate(withDuration: 0.1,  animations: {
//            cell!.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
//        }, completion: nil)
//        animate(cell, transform: CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85))
    }
    
//    private func animate(_ view: UIView, transform: CGAffineTransform) {
//        UIView.animate(withDuration: 0.1,  animations: {
//            view.transform = transform
//        }, completion: nil)
//    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct ClassesScheduleView_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        return ClassesScheduleView()
    }
}

struct ClassesScheduleView_PreviewView: View {
    var body: some View {
        ClassesScheduleView_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct ClassesScheduleView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            ClassesScheduleView_PreviewView()
                .previewLayout(.fixed(width: 346, height: 500))
                .preferredColorScheme(.light)
            
            ClassesScheduleView_PreviewView()
                .previewLayout(.fixed(width: 346, height: 500))
                .preferredColorScheme(.dark)
        }
    }
}
