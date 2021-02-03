//
//  ViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 09/12/2020.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    private var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = "SCHEDULE"
        label.font = UIFont.helveticaNeue(ofSize: 30)
        label.textColor = .energyContainerColor
        return label
    }()
    
    
    // MARK: - Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .energyBackgroundColor
        configureUI()
        
        
        
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        configureTopCornerDate()
    }
    
    private func configureTopCornerDate() {
        let dateContainer = TopCornerDateView()
//        dateContainer.backgroundColor = .green
        view.addSubview(dateContainer)
        dateContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10,
                                leading: view.safeAreaLayoutGuide.leadingAnchor, paddingLeading: 22)
        
        
        view.addSubview(pageNameLabel)
//        pageNameLabel.backgroundColor = .yellow
        pageNameLabel.anchor(top: dateContainer.bottomAnchor, paddingTop: -10,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTrailing: 25)
        
        
        let container = UIView()
        view.addSubview(container)
        container.backgroundColor = .energyContainerColor
        container.anchor(top: pageNameLabel.bottomAnchor, paddingTop: -6.2,
                         leading: view.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.trailingAnchor)
        container.layer.cornerRadius = 26
    }
    
}



// -------------- SWIFTUI PREVIEW HELPER --------------------
struct TestIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
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
        TestPreviewController().previewDevice("iPhone X").preferredColorScheme(.light)
    }
}

