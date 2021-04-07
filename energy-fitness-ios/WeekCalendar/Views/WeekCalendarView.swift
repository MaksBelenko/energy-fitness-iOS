//
//  WeekCalendarView.swift
//  WeekCalendar
//
//  Created by Maksim on 07/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

protocol DateSelectedDelegate: AnyObject {
    func onDateSelected(date: DateObject)
}

protocol WeekCalendarViewProtocol: UIView {
    var delegate: DateSelectedDelegate? { get set }
    var selectedDateSubject: PassthroughSubject<DateObject, Never> { get set }
}

class WeekCalendarView: UIView, WeekCalendarViewProtocol {
    
    weak var delegate: DateSelectedDelegate?
    var selectedDateSubject = PassthroughSubject<DateObject, Never>()
    
    private var viewModel: WeekCalendarVMProtocol!
    private var spacingBetweenCells: CGFloat!
    
    
    private let numberOfDisplayedCells: CGFloat = 7 // 7 days to show
    private var constraintsCV: [NSLayoutConstraint]!
    
    lazy var weekCollectionView: UICollectionView = {
        let layout = HorizontalFloatingHeaderLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    
    // MARK: - Injection
    static func create(cellSpacing spacingBetweenCells: CGFloat, viewModel: WeekCalendarVMProtocol) -> WeekCalendarView {
        let view = WeekCalendarView()
        view.spacingBetweenCells = spacingBetweenCells
        view.viewModel = viewModel
        
        var dateComp = DateComponents()
        dateComp.year = 2020
        dateComp.month = 11
        dateComp.day = 7
        viewModel.setStartDate(to: Date.calendar.date(from: dateComp)!)
        return view
    }
    
    
    // MARK: - Lifecycle
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(weekCollectionView)
        
        constraintsCV = [
            weekCollectionView.topAnchor.constraint(equalTo: topAnchor),
            weekCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
//        NSLayoutConstraint.deactivate(constraintsCV)
        NSLayoutConstraint.activate(constraintsCV)
    }
    
    private func registerCells() {
        weekCollectionView.register(DateSelectorCell.self,
                                    forCellWithReuseIdentifier: DateSelectorCell.identifier)
        weekCollectionView.register(MonthNameHeader.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: MonthNameHeader.identifier)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeekCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = weekCollectionView.cellForItem(at: indexPath) as! DateCellProtocol
        cell.selectCell(true, animated: true)
        
        let oldIndexPath = viewModel.setSelectedCell(indexPath: indexPath)
        if oldIndexPath != indexPath {
            let oldCell = weekCollectionView.cellForItem(at: oldIndexPath) as? DateCellProtocol
            oldCell?.selectCell(false, animated: false)
            
            let selectedDate = viewModel.getDate(from: indexPath)
            delegate?.onDateSelected(date: selectedDate)
            selectedDateSubject.send(selectedDate)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension WeekCalendarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfDays(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: DateSelectorCell.identifier, for: indexPath) as! DateCellProtocol

        let day = viewModel.getDay(for: indexPath)
        cell.selectCell(day.isSelected, animated: false)
        cell.weekDayLabel.text = day.weekDay.getLocalisedString(format: .OneLetter).uppercased()
        cell.dayLabel.text = "\(day.number)"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // removing item at indexPath for resuing cell
//        print("Removing at \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MonthNameHeader.identifier, for: indexPath) as! MonthNameHeader
        header.monthNameLabel.text = viewModel.getMonthName(for: indexPath.section)
        return header
    }
    
}


// MARK: - HorizontalFloatingHeaderLayoutDelegate
extension WeekCalendarView: HorizontalFloatingHeaderLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderItemSizeAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.height - viewModel.getMonthNameSize(for: indexPath.section).height
        let totalSpacing = numberOfDisplayedCells * spacingBetweenCells
        let width = (weekCollectionView.bounds.width - totalSpacing)/numberOfDisplayedCells
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderSizeAt section: Int) -> CGSize {
        return viewModel.getMonthNameSize(for: section)
    }
    
    //Line Spacing
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderColumnSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //Section Insets
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderSectionInsetAt section: Int) -> UIEdgeInsets {
        let leftOffset = (section == 0) ? self.spacingBetweenCells/2 : 0
        return UIEdgeInsets(top: 0, left: leftOffset, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderItemSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacingBetweenCells
    }
    
}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct WeekCalendarView_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        let container = DIContainer.staticContainerSwiftUIPreviews
        let viewModel = container.resolve(WeekCalendarVMProtocol.self)!
        return WeekCalendarView.create(cellSpacing: 4, viewModel: viewModel)
    }
}

struct WeekCalendarView_PreviewView: View {
    var body: some View {
        WeekCalendarView_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            WeekCalendarView_PreviewView()
                .previewLayout(.fixed(width: 370, height: 78))
                .preferredColorScheme(.light)
        }
    }
}
