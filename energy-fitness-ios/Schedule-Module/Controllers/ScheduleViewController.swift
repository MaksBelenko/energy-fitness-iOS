//
//  ViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 09/12/2020.
//

import UIKit
import SwiftUI

class ScheduleViewController: UIViewController {

    private var weekCalendarView: WeekCalendarViewProtocol
    
    private var topCornerDateView: TopCornerDateView!
    private let gymClassesView = ClassesScheduleView()
    
    private var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("schedule", comment: "Schedule header of ScheduleViewController").uppercased()
        label.font = UIFont.helveticaNeue(ofSize: 30)
        label.textColor = .energyContainerColor
        return label
    }()
    
    let urlSession = URLSessionAdapter()
    
    // MARK: - Initialisation
    
    init(weekCalendarView: WeekCalendarViewProtocol) {
        self.weekCalendarView = weekCalendarView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("Loaded")
        super.viewDidLoad()
        
        view.backgroundColor = .energyBackgroundColor
        configureUI()
        configureSubscriptions()
    }
    
    deinit {
        print("Deinit on \(String(describing: self))")
    }
    
    
    
    private func configureSubscriptions() {
        gymClassesView.delegate = self
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
        
        view.addSubview(weekCalendarView)
        weekCalendarView.anchor(top: scheduleViewContainer.topAnchor, paddingTop: 15,
                        leading: scheduleViewContainer.leadingAnchor, paddingLeading: 15,
                        trailing: scheduleViewContainer.trailingAnchor, paddingTrailing: 15,
                        height: 78)
        
        /* Schedule collection view */
        scheduleViewContainer.addSubview(gymClassesView)
        gymClassesView.anchor(top: weekCalendarView.bottomAnchor, paddingTop: 30,
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

extension ScheduleViewController: CellSelectedDelegate {
    func onCellSelected() {
        let bookVC = BookClassViewController()
        bookVC.modalPresentationStyle = .fullScreen
        present(bookVC, animated: true, completion: nil)
        print("Cell Selected")
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

