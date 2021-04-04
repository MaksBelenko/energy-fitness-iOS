//
//  ViewController.swift
//  energy-fitness-iOS
//
//  Created by Maksim on 09/12/2020.
//

import UIKit
import SwiftUI
import Combine

extension ScheduleViewController: UIPopoverPresentationControllerDelegate {}

final class ScheduleViewController: UIViewController {
    
    weak var coordinator: ScheduleTabCoordinator?
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let weekCalendarView: WeekCalendarViewProtocol
    private let scheduleView: ScheduleViewProtocol
    private var topCornerDateView: TopCornerDateView!
    
    private lazy var sortButton: UIView = {
        let view = UIView()
        let icon = UIImageView()
        icon.image = UIImage(systemName: "line.horizontal.3.decrease.circle")
        icon.tintColor = .energyOrange
        view.addSubview(icon)
        icon.contain(in: view)
        return view
    }()
    
    private var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("schedule", comment: "Schedule header of ScheduleViewController").uppercased()
        label.font = UIFont.helveticaNeue(ofSize: 30)
        label.textColor = .energyContainerColor
        return label
    }()
    
    let dropDownMenu = SortDropDownMenu<ScheduleShowStatus>()
    
    // MARK: - Lifecycle
    
    init(
        weekCalendarView: WeekCalendarViewProtocol,
        scheduleView: ScheduleViewProtocol
    ) {
        self.weekCalendarView = weekCalendarView
        self.scheduleView = scheduleView
        super.init(nibName: nil, bundle: nil)
    }
    
//    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
//        return .none
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .energyBackgroundColor
        configureUI()
        configureSubscriptions()
    }
    
    deinit {
        Log.logDeinit(String(describing: self))
    }
    
    
    
    // MARK: - Subscriptions configuration
    private func configureSubscriptions() {
        sortButton.gesture(.tap())
            .sink { [weak self] gestureType in
                guard let self = self else { return }
                let popoverPresentationController = self.dropDownMenu.createDropDownMenu(for: self.sortButton, ofSize: CGSize(width: 200, height: 130))
                popoverPresentationController?.delegate = self
//                dropDownMenu.sortButtonLabelDelegate = self
                self.present(self.dropDownMenu.tableViewController, animated: true, completion: nil)
                print("tapped")
            }
            .store(in: &subscriptions)
            
        
        scheduleView.selectedCell
            .sink { [weak self] session in
                self?.coordinator?.showBookSession(for: session)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        configureTopCornerDate()
        configurePageNameLabel()
        configureScheduleViewContainer()
    }
    
    private func configureTopCornerDate() {
        topCornerDateView = TopCornerDateView()
        view.addSubview(topCornerDateView)
        topCornerDateView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: view.safeAreaLayoutGuide.leadingAnchor, paddingLeading: 22)
        
        topCornerDateView.setDateToBeShown(date: Date())
    }
    
    private func configurePageNameLabel() {
        view.addSubview(pageNameLabel)
        pageNameLabel.anchor(top: topCornerDateView.bottomAnchor, paddingTop: -10,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTrailing: 25)
    }
    
    private func configureScheduleViewContainer() {
        /* Container setup */
        let scheduleViewContainer = UIView()
        scheduleViewContainer.layer.cornerRadius = 26
        scheduleViewContainer.clipsToBounds = true
        
        view.addSubview(scheduleViewContainer)
        scheduleViewContainer.backgroundColor = .energyContainerColor
        scheduleViewContainer.anchor(top: pageNameLabel.bottomAnchor, paddingTop: -6.2,
                                     leading: view.leadingAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     trailing: view.trailingAnchor)
        
        /* Week Calendar View */
        weekCalendarView.delegate = self
        
        scheduleViewContainer.addSubview(weekCalendarView)
        weekCalendarView.anchor(top: scheduleViewContainer.topAnchor, paddingTop: 15,
                        leading: scheduleViewContainer.leadingAnchor, paddingLeading: 15,
                        trailing: scheduleViewContainer.trailingAnchor, paddingTrailing: 15,
                        height: 73)
        
        /* Filter Button */
        scheduleViewContainer.addSubview(sortButton)
        sortButton.anchor(top: weekCalendarView.bottomAnchor, paddingTop: 5,
                            trailing: scheduleViewContainer.trailingAnchor, paddingTrailing: 25,
                            width: 30, height: 30)

        /* Schedule collection view */
        scheduleViewContainer.addSubview(scheduleView)
        scheduleView.anchor(top: sortButton.bottomAnchor, paddingTop: 5,
                           leading: scheduleViewContainer.leadingAnchor,
                           bottom: scheduleViewContainer.bottomAnchor,
                           trailing: scheduleViewContainer.trailingAnchor)
    }
}

// MARK: - DateSelectedDelegate extension
extension ScheduleViewController: DateSelectedDelegate {
    func onDateSelected(date: DateObject) {
        print("Selected date = \(date)")
    }
}









// -------------- SWIFTUI PREVIEW HELPER --------------------
struct TestIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let container = DIContainer.staticContainerSwiftUIPreviews
        let vc = container.resolve(ScheduleViewController.self)!
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct TestPreviewController: View {
    var body: some View {
        TestIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct TestPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        TestPreviewController()
            .previewDevice("iPhone X")
            .preferredColorScheme(.light)
            .environment(\.locale, .init(identifier: "ru"))
    }
}

