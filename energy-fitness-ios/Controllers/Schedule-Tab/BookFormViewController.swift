//
//  BookFormViewController.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 19/03/2021.
//

import UIKit
import SwiftUI

class BookFormViewController: UIViewController {

    private lazy var fullNameTextField: EnergyTextField = {
        let textField = EnergyTextField()
        textField.smallPlaceholderText = "Enter your full name"
        textField.placeholder = "Full name"
        return textField
    }()
    
    private lazy var emailTextField: EnergyTextField = {
        let textField = EnergyTextField()
        textField.smallPlaceholderText = "Enter your email"
        textField.placeholder = "Email"
        return textField
    }()
    
    private lazy var phoneTextField: EnergyTextField = {
        let textField = EnergyTextField()
        textField.smallPlaceholderText = "Enter your phone number"
        textField.placeholder = "Phone number"
        return textField
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.energyBookFormOuter.withAlphaComponent(0.15)
        
        stackView.addArrangedSubview(fullNameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(phoneTextField)
        
        fullNameTextField.anchor(height: 50)
        emailTextField.anchor(height: 50)
        phoneTextField.anchor(height: 50)
        
        view.addSubview(stackView)
        stackView.centerY(withView: view)
        stackView.centerX(withView: view)
        stackView.anchor(width: 300, height: 200)
    }

    
    override func viewDidLayoutSubviews() {
        print("Intrinsic size \(stackView.intrinsicContentSize)")
    }
}




// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------------
struct BookFormIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return BookFormViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct BookFormPreviewController: View {
    var body: some View {
        BookFormIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct BookForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookFormPreviewController()
                .previewDevice("iPhone X")
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "ru"))
            
            BookFormPreviewController()
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}
