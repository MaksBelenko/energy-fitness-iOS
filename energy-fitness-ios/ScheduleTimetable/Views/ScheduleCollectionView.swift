//
//  ScheduleCollectionViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit
import SwiftUI
import Combine

protocol CellSelectedDelegate: AnyObject {
    func onCellSelected()
}

protocol ScheduleViewProtocol: UIView {
    var delegate: CellSelectedDelegate? { get set }
}

class ScheduleView: UIView, ScheduleViewProtocol {
    
    weak var delegate: CellSelectedDelegate?
    
    private var viewModel: ScheduleViewModelProtocol
    
    private var headerReuseIdentifier: String!
    private var realReuseIdentifier: String!
    
    private let noSessionView: NoSessionView = {
        let view = NoSessionView()
        view.isHidden = true
        return view
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return layout
    }()
    
    private lazy var scheduleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
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
    init(viewModel: ScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureUI()
        setupCells()
        
//        scheduleCollectionView.isScrollEnabled = false
        
        
        /* Set View Model */
        self.viewModel.delegate = self
        self.viewModel.enableLoadingAnimation()
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
    }
    
    
    private func configureUI() {
        addSubview(scheduleCollectionView)
        scheduleCollectionView.contain(in: self)
        
        addSubview(noSessionView)
        noSessionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSessionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            noSessionView.heightAnchor.constraint(equalToConstant: 180),
            noSessionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noSessionView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ScheduleView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getNumberOfSections()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: realReuseIdentifier, for: indexPath) as! ScheduleCell
        let cellViewModel = viewModel.getViewModel(for: indexPath)
        cell.setViewModel(to: cellViewModel)
//        cell.isTextLoading = true
//        cell.isImagesLoading = true
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension ScheduleView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        return CGSize(width: width - 5, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ScheduleHeaderCell
        header.setTimeLabelText(to: viewModel.getTextForHeader(at: indexPath.section))
        header.isLoading = true
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
extension ScheduleView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)!
        delegate?.onCellSelected()
    }
}

extension ScheduleView: ScheduleViewModelDelegate {
    func reloadData() {
        scheduleCollectionView.reloadData()
    }
}










// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct ClassesScheduleView_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        let container = DIContainer.staticContainerSwiftUIPreviews
        let viewModel = container.resolve(ScheduleViewModelProtocol.self)!
        return ScheduleView(viewModel: viewModel)
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
