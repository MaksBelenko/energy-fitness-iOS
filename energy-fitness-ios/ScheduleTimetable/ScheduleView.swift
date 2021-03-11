//
//  ScheduleCollectionViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit
import SwiftUI
import Combine
import CombineDataSources

protocol CellSelectedDelegate: AnyObject {
    func onCellSelected()
}

protocol ScheduleViewProtocol: UIView {
    var delegate: CellSelectedDelegate? { get set }
}

class ScheduleView: UIView, ScheduleViewProtocol {
    
    weak var delegate: CellSelectedDelegate?
    
    private var viewModel: ScheduleViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private var headerReuseIdentifier: String!
    private var realReuseIdentifier: String!

    private var dataSource: UICollectionViewDiffableDataSource<Section<GymSessionDto>, GymSessionDto>?
    
    private let noSessionView: NoSessionView = {
        let view = NoSessionView()
        view.isHidden = true
        return view
    }()
    
    private lazy var scheduleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    
    
    // MARK: - Lifecycle
    init(viewModel: ScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureUI()
        registerCells()
        
//        scheduleCollectionView.isScrollEnabled = false
        
        createDataSource()
//        reloadData(with: viewModel.organisedSessions.value)
        
        
        self.viewModel.organisedSessions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] organisedSessions in
                self?.reloadData(with: organisedSessions)
            }
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCells() {
        headerReuseIdentifier = ScheduleHeaderCell.reuseIdentifier()
        scheduleCollectionView.register(ScheduleHeaderCell.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: headerReuseIdentifier)
        
        realReuseIdentifier = ScheduleCell.reuseIdentifier()
        scheduleCollectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: realReuseIdentifier)
    }
    
    
    
    // MARK: - Collection View
    private func createDataSource() {
        dataSource = .init(collectionView: scheduleCollectionView, cellProvider: { [weak self] (collectionView, indexPath, gymSession) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            print("---Data source index path section = \(indexPath.section) row = \(indexPath.row)")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.realReuseIdentifier, for: indexPath) as! ScheduleCell
            let viewModel = ScheduleCellViewModel(gymSession: gymSession)
            cell.setViewModel(to: viewModel)
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            print("Supplimentary view for section =  \(indexPath.section) row =  \(indexPath.row)")
            guard let self = self else { return nil }
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerReuseIdentifier, for: indexPath) as? ScheduleHeaderCell else {
                return nil
            }
            
            guard let firstSession = self.dataSource?.itemIdentifier(for: indexPath),
                  let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: firstSession),
                  let header = section.header else {
//                return nil
                print("Didnt reach so default header... \(self.dataSource?.itemIdentifier(for: indexPath)?.trainer)")
                sectionHeader.isLoading = true
                return sectionHeader
            }
            
            print("Header name \(header)")
            sectionHeader.isLoading = false
            sectionHeader.setTimeLabelText(to: header)
            return sectionHeader
        }
    }
    
    
    private func reloadData(with sessions: [Section<GymSessionDto>] ) {
        var snapshot = NSDiffableDataSourceSnapshot<Section<GymSessionDto>, GymSessionDto>()
        snapshot.appendSections(sessions)
        
        for section in sessions {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
//            let section = self.viewModel.organisedSessions.value[sectionIndex]
            return self.createLayoutSection()
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        layout.configuration = config
        return layout
    }
    
    func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 2, trailing: 5)
//        layoutItem.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(2))

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        layoutSectionHeader.pinToVisibleBounds = true
        return layoutSectionHeader
    }
    
    
    // MARK: - UI Configuration
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

// MARK: - UICollectionViewDelegateFlowLayout
//extension ScheduleView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = self.frame.width
//        return CGSize(width: width - 5, height: 100)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ScheduleHeaderCell
////        header.setTimeLabelText(to: viewModel.getTextForHeader(at: indexPath.section))
////        header.isLoading = viewModel.checkIfLoadingHeader()
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: self.frame.width, height: 30)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5.0, left: 0, bottom: 15, right: 0)
//    }
//
//}

// MARK: - UICollectionViewDelegate
//extension ScheduleView: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let cell = collectionView.cellForItem(at: indexPath)!
//        delegate?.onCellSelected()
//    }
//}

//extension ScheduleView: ScheduleViewModelDelegate {
//    func reloadData() {
//        scheduleCollectionView.reloadData()
//    }
//}










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
