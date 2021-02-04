//
//  ViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 09/12/2020.
//

import UIKit
import SwiftUI

class ScheduleViewController: UIViewController {

    private var topCornerDateView: TopCornerDateView!
    
    private var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("schedule", comment: "Schedule header of ScheduleViewController").uppercased()
        label.font = UIFont.helveticaNeue(ofSize: 30)
        label.textColor = .energyContainerColor
        return label
    }()
    
    
    // MARK: - Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .energyBackgroundColor
        configureUI()
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
        let scheduleViewContainer = UIView()
        scheduleViewContainer.layer.cornerRadius = 26
        
        view.addSubview(scheduleViewContainer)
        scheduleViewContainer.backgroundColor = .energyContainerColor
        scheduleViewContainer.anchor(top: pageNameLabel.bottomAnchor, paddingTop: -6.2,
                                     leading: view.leadingAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     trailing: view.trailingAnchor)
        
        
        let weekView = WeekViewBuilder()
                        .withNumberOfWeeks(8)
                        .withFirstDayOfWeek(.Monday)
                        .build()
    
        weekView.delegate = self
        
        view.addSubview(weekView)
        weekView.anchor(top: scheduleViewContainer.topAnchor, paddingTop: 15,
                        leading: scheduleViewContainer.leadingAnchor, paddingLeading: 15,
                        trailing: scheduleViewContainer.trailingAnchor, paddingTrailing: 15,
                        height: 78)
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
        return ScheduleViewController()
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
    
//    static var previews: some View {
//            ForEach(["en", "ru"], id: \.self) { id in
//                TestPreviewController()
//                    .previewDevice("iPhone X")
//                    .preferredColorScheme(.light)
//                    .environment(\.locale, .init(identifier: id))
//            }
//        }
}

