//
//  SignupViewController.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 03/05/2021.
//

import UIKit
import Combine
import SwiftUI

final class SignupViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    
    private let viewModel: SignupViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private lazy var backgroundView: UIImageView = {
        let imageView = DarkenedImageView(image: #imageLiteral(resourceName: "intro-gym"))
        return imageView
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "energy-logo-transparent"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var fullNameTextField: EnergyTextField = {
        let textField = EnergyTextField()
        let fullNameLocalisedTitle = NSLocalizedString("Full name", comment: "Text placeholder")
        textField.placeholder = fullNameLocalisedTitle
        textField.smallPlaceholderText = fullNameLocalisedTitle
        textField.smallPlaceHolderBackgroundColour = textField.backgroundColor!.darker(by: 8)!
        textField.keyboardType = .alphabet
        return textField
    }()
    
    private lazy var emailTextField: EnergyTextField = {
        let textField = EnergyTextField()
        let emailLocalisedTitle = NSLocalizedString("Email", comment: "Text placeholder")
        textField.placeholder = emailLocalisedTitle
        textField.smallPlaceholderText = emailLocalisedTitle
        textField.smallPlaceHolderBackgroundColour = textField.backgroundColor!.darker(by: 8)!
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: EnergyTextField = {
        let textField = EnergyTextField()
        let passwordLocalisedTitle = NSLocalizedString("Password", comment: "Text placeholder")
        textField.placeholder = passwordLocalisedTitle
        textField.smallPlaceholderText = passwordLocalisedTitle
        textField.smallPlaceHolderBackgroundColour = textField.backgroundColor!.darker(by: 8)!
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        return textField
    }()
    
    
    private lazy var signupButton: AuthButton = {
        let button = AuthButton()
        button.title = NSLocalizedString("Sign up", comment: "Login and Signup items")
        button.isActive = false
        button.textFont = .raleway(ofSize: 19)
        return button
    }()
    
    private lazy var haveAccountButton: AccountButton = {
        let button = AccountButton(type: .system)
        let signupQuestion = NSLocalizedString("already_have_account_question", comment: "Login and Signup items")
        let loginText = NSLocalizedString("Login", comment: "Login and Signup items")
        button.setupLabel(question: signupQuestion, actionName: loginText)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    init(coordinator: AuthCoordinator, viewModel: SignupViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createControllerViewsBindings()
        createViewModelBindings()
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
        
        let stack = UIStackView(arrangedSubviews: [fullNameTextField,
                                                   emailTextField,
                                                   passwordTextField,
                                                   signupButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 12
        stack.setCustomSpacing(30, after: passwordTextField)

        view.addSubview(stack)
        stack.anchor(top: logo.bottomAnchor, paddingTop: 40,
                     leading: view.leadingAnchor, paddingLeading: 40,
                     trailing: view.trailingAnchor, paddingTrailing: 40)
        
        
        view.addSubview(haveAccountButton)
        haveAccountButton.centerX(withView: view)
        haveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    //MARK: - Bindings
    private func createControllerViewsBindings() {
        
        fullNameTextField.textPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .assign(to: \.fullNameSubject.value, on: viewModel)
            .store(in: &subscriptions)
        
        emailTextField.textPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .assign(to: \.emailSubject.value, on: viewModel)
            .store(in: &subscriptions)
        
        passwordTextField.textPublisher
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .assign(to: \.passwordSubject.value, on: viewModel)
            .store(in: &subscriptions)
        
        /* Enter press publishers */
        fullNameTextField.publisher(for: .editingDidEndOnExit)
            .sink { [weak self] in
                self?.emailTextField.becomeFirstResponder()
            }
            .store(in: &subscriptions)
        
        emailTextField.publisher(for: .editingDidEndOnExit)
            .sink { [weak self] in
                self?.passwordTextField.becomeFirstResponder()
            }
            .store(in: &subscriptions)
        
        passwordTextField.keyboardReturnPublisher
            .sink { [weak self] in
                self?.view.endEditing(true)
            }
            .store(in: &subscriptions)
        
        /* Tap press publishers */
        view.gesture(.tap())
            .sink { [weak self] _
                in self?.view.endEditing(true)
            }
            .store(in: &subscriptions)
        
//        signupButton.tapPublisher
//            .handleEvents(receiveOutput: { [weak self] _ in
//                self?.signupButton.isLoading = true
//                self?.view.endEditing(true)
//            })
//            .flatMap(viewModel.signinAction)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] signedIn in
//                self?.signupButton.isLoading = false
//                print("SignedIn? \(signedIn)")
//            }
//            .store(in: &subscriptions)
        
        haveAccountButton.tapPublisher
            .sink { [weak coordinator] _ in
                coordinator?.backToLogin()
            }
            .store(in: &subscriptions)
    }
    
    private func createViewModelBindings() {
        viewModel.isFullNameValid() 
            .map { $0 ? UIColor.energyTFPlaceholderColour : UIColor.systemRed }
            .assign(to: \.smallPlaceholderColor, on: fullNameTextField)
            .store(in: &subscriptions)
        
        viewModel.isEmailValid()
            .map { $0 ? UIColor.energyTFPlaceholderColour : UIColor.systemRed }
            .assign(to: \.smallPlaceholderColor, on: emailTextField)
            .store(in: &subscriptions)
        
        viewModel.isPasswordValid()
            .map { $0 ? UIColor.energyTFPlaceholderColour : UIColor.systemRed }
            .assign(to: \.smallPlaceholderColor, on: passwordTextField)
            .store(in: &subscriptions)
        
        viewModel.isValidInputs()
            .assign(to: \.isActive, on: signupButton)
            .store(in: &subscriptions)
    }
}










// -------------- SWIFTUI PREVIEW HELPER --------------------
struct SignupIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let container = DIContainer.staticContainerSwiftUIPreviews
        return container.resolve(SignupViewController.self)!
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct SignupPreviewController: View {
    var body: some View {
        SignupIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct SignupPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignupPreviewController()
                .previewDevice("iPhone X")
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "ru"))
            
            SignupPreviewController()
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "ru"))
        }
    }
}

