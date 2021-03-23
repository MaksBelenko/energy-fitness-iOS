//
//  LoginViewController.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/03/2021.
//

import UIKit
import Combine
import SwiftUI

final class LoginViewController: UIViewController {

    private var subscriptions = Set<AnyCancellable>()
    private let viewModel = LoginViewModel()
    
    private lazy var backgroundView: DarkenedImageView = {
        let imageView = DarkenedImageView(image: #imageLiteral(resourceName: "intro-gym"))
        return imageView
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "energy-logo-transparent"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var emailTextField: EnergyTextField = {
        let textField = EnergyTextField()
        textField.placeholder = NSLocalizedString("Email", comment: "Text placeholder")
        textField.smallPlaceholderText = NSLocalizedString("Email", comment: "Text placeholder")
        return textField
    }()
    
    private lazy var passwordTextField: EnergyTextField = {
        let textField = EnergyTextField()
        textField.placeholder = NSLocalizedString("Password", comment: "Text placeholder")
        textField.smallPlaceholderText = NSLocalizedString("Password", comment: "Text placeholder")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton: AuthButton = {
        let button = AuthButton()
        button.title = NSLocalizedString("Login", comment: "Login and Signup items")
        button.isActive = true
        button.textFont = .raleway(ofSize: 18)
        return button
    }()
    
    private lazy var haveAccountButton: AccountButton = {
        let button = AccountButton(type: .system)
        let loginQuestion = NSLocalizedString("Don't have an account?", comment: "Login and Signup items")
        let signupText = NSLocalizedString("Sign up", comment: "Login and Signup items")
        button.setupLabel(question: loginQuestion, actionName: signupText)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBindings()
        configureUI()
        
    }
    
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.addSubview(backgroundView)
        backgroundView.contain(in: view)
        
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            logo.heightAnchor.constraint(equalTo: logo.widthAnchor),
            logo.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3)
        ])
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,
                                                   passwordTextField,
                                                   loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.setCustomSpacing(30, after: passwordTextField)

        view.addSubview(stack)
        stack.anchor(top: logo.bottomAnchor, paddingTop: 40,
                     leading: view.leadingAnchor, paddingLeading: 40,
                     trailing: view.trailingAnchor, paddingTrailing: 40)
        
        
        view.addSubview(haveAccountButton)
        haveAccountButton.centerX(withView: view)
        haveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
    }
    
    //MARK: - Bindings
    private func createBindings() {
        
//        loginButton.publisher(for: .touchUpInside)
//            .setFailureType(to: Error.self)
//            .flatMap {
//                self.authenticator.signin(with: SigninDto(email: "maksim.belenko@gmail.com", password: "Test123!"))
//            }
//            .sink(receiveCompletion: { completion in
//                print("\(completion)")
//            }, receiveValue: { tokensDto in
//                print("TokensDto \(tokensDto)")
//            })
//            .store(in: &subscriptions)
        
        emailTextField.textPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .assign(to: \.emailSubject.value, on: viewModel)
            .store(in: &subscriptions)
        
        passwordTextField.textPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .assign(to: \.passwordSubject.value, on: viewModel)
            .store(in: &subscriptions)
        
        viewModel.isValidInputs()
            .assign(to: \.isActive, on: loginButton)
            .store(in: &subscriptions)
    }
    
}










// -------------- SWIFTUI PREVIEW HELPER --------------------
struct LoginIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return LoginViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct LoginPreviewController: View {
    var body: some View {
        LoginIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct LoginPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginPreviewController()
                .previewDevice("iPhone X")
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "ru"))
            
            LoginPreviewController()
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "ru"))
        }
    }
}
