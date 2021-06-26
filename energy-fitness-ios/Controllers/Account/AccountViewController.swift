//
//  SettingsViewController.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/06/2021.
//

import UIKit
import SwiftUI

final class AccountViewController: UIViewController {

    private var signupButton: PaddedButton = {
        let button = PaddedButton(top: 10, bottom: 10, left: 20, right: 20)
        button.backgroundColor = .energyOrange
        button.text = NSLocalizedString("Sign up", comment: "Login and Signup items")
        button.textFont = .raleway(ofSize: 17)
        button.textColour = .white
        button.layer.cornerRadius = 7
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .energyWhiteBlack
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = "Test"
        
        configureUI()
    }
    
    
    private func configureUI() {
        view.addSubview(signupButton)
        signupButton.centerX(withView: view)
        signupButton.centerY(withView: view)
    }
}



// -------------- SWIFTUI PREVIEW HELPER --------------------
struct AccountIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let accountVC = AccountViewController()
        let nav = UINavigationController(rootViewController: accountVC)
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct AccountPreviewController: View {
    var body: some View {
        AccountIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct AccountPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountPreviewController()
                .previewDevice("iPhone X")
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "ru"))
            
//            AccountPreviewController()
//                .previewDevice("iPhone 8")
//                .preferredColorScheme(.dark)
//                .environment(\.locale, .init(identifier: "ru"))
        }
    }
}
