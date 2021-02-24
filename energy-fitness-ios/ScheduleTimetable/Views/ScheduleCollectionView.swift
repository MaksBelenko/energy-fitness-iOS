//
//  ScheduleCollectionViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit
import SwiftUI

protocol CellSelectedDelegate: AnyObject {
    func onCellSelected()
}

class ClassesScheduleView: UIView {
    
    weak var delegate: CellSelectedDelegate?
    
    private var viewModel: ScheduleViewModel!
    
    private var headerReuseIdentifier: String!
    private var realReuseIdentifier: String!
    private var shimmerReuseIdentifier: String!
    
    private lazy var collectionViewFlLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return layout
    }()
    
    private lazy var scheduleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlLayout)
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
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scheduleCollectionView)
        scheduleCollectionView.contain(in: self)
        
        setupCells()
        
        /* Set View Model */
        viewModel = ScheduleViewModel(cellReuseIdentifier: realReuseIdentifier,
                                      shimmerReuseIdentifier: shimmerReuseIdentifier)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCells() {
        headerReuseIdentifier = ScheduleHeaderCell.reuseIdentifier()
        scheduleCollectionView.register(ScheduleHeaderCell.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: headerReuseIdentifier)
        
        realReuseIdentifier = ScheduleCell.reuseIdentifier()
        scheduleCollectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: realReuseIdentifier)
        
        shimmerReuseIdentifier = ShimmerScheduleCell.reuseIdentifier()
        scheduleCollectionView.register(ShimmerScheduleCell.self, forCellWithReuseIdentifier: shimmerReuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension ClassesScheduleView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getNumberOfSections()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = viewModel.getCurrentReuseIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension ClassesScheduleView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        return CGSize(width: width - 5, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ScheduleHeaderCell
        header.setTimeLabelText(to: viewModel.getTextForHeader(at: indexPath.section))
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 0, bottom: 15, right: 0)
    }

}

// MARK: - UICollectionViewDelegate
extension ClassesScheduleView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)!
        delegate?.onCellSelected()
    }
}

extension ClassesScheduleView: ScheduleViewModelDelegate {
    func reloadData() {
        scheduleCollectionView.reloadData()
    }
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
