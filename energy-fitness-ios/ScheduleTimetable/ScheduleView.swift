//
//  ScheduleCollectionViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit
import SwiftUI
import Combine

protocol ScheduleViewProtocol: UIView {
    var sortingOptionChangedSubject: PassthroughSubject<ScheduleFilterType, Never> { get set }
    var selectedCell: PassthroughSubject<GymSessionDto, Never> { get set }
}

final class ScheduleView: UIView, ScheduleViewProtocol {
    
    /// Publish the change in sorting to the view
    var sortingOptionChangedSubject = PassthroughSubject<ScheduleFilterType, Never>()
    
    var selectedCell = PassthroughSubject<GymSessionDto, Never>()
    private var viewModel: ScheduleViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private var headerReuseIdentifier: String!
    private var realReuseIdentifier: String!

    private var dataSource: UICollectionViewDiffableDataSource<Section<GymSessionDto>, GymSessionDto>?
    
    private lazy var noSessionView: NoSessionView = {
        let view = NoSessionView(image: #imageLiteral(resourceName: "nosessions"), text: NSLocalizedString("No sessions", comment: "No session text"))
        view.isHidden = true
        return view
    }()
    
    private lazy var noInternetConnectionView: NoSessionView = {
        let view = NoSessionView(image: #imageLiteral(resourceName: "no-wifi"), text: NSLocalizedString("No Internet Connection", comment: "No Internet Connection image label"))
        view.isHidden = true
        return view
    }()
    
    private lazy var scheduleCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        
        return collectionView
    }()
    
    
    
    // MARK: - Lifecycle
    init(viewModel: ScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureUI()
        bindInputs()
        bindViewModel()
        registerCells()
        createDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        addSubview(noInternetConnectionView)
        noInternetConnectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noInternetConnectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            noInternetConnectionView.heightAnchor.constraint(equalToConstant: 180),
            noInternetConnectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noInternetConnectionView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30)
        ])
    }
    
    // MARK: - Bindings
    private func bindInputs() {
        sortingOptionChangedSubject
            .sink { [weak self] newSortingType in
                self?.viewModel.changeOrder(by: newSortingType)
            }
            .store(in: &subscriptions)
    }
    
    private func bindViewModel() {
        viewModel.organisedSessions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] organisedSessions in
                print("***Number of sessions = \(organisedSessions.count)")
                self?.reloadData(with: organisedSessions)
            }
            .store(in: &subscriptions)
        
        viewModel.showNoConnectionIcon
            .receive(on: DispatchQueue.main)
            .invert()
            .assign(to: \.isHidden, on: noInternetConnectionView)
            .store(in: &subscriptions)
        
        viewModel.showNoEventsIcon
            .receive(on: DispatchQueue.main)
            .invert()
            .assign(to: \.isHidden, on: noSessionView)
            .store(in: &subscriptions)
    }
    
    
    
    // MARK: - Cell Registration
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
            print("-Data source index path section = \(indexPath.section) row = \(indexPath.row)")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.realReuseIdentifier, for: indexPath) as! ScheduleCell
            let viewModel = ScheduleCellViewModel(gymSession: gymSession)
            cell.setViewModel(to: viewModel)
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerReuseIdentifier, for: indexPath) as? ScheduleHeaderCell else {
                return nil
            }

            guard let firstSession = self.dataSource?.itemIdentifier(for: indexPath),
                  let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: firstSession),
                  let header = section.header else {
                return nil
            }
            
            print("DEBUG: *****Header with name \(header)")
            sectionHeader.isLoading = header == ""
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
        
        print("+++______________ calling datasource apply _____________________+++")
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createLayoutSection()
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 20
        
        layout.configuration = config
        return layout
    }
    
    func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(5))

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
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
}

// MARK: - UICollectionViewDelegate
extension ScheduleView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let allSessions = viewModel.organisedSessions.value
        let session = allSessions[indexPath.section][indexPath.row]
        selectedCell.send(session)
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
