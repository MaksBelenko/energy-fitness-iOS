//
//  BookClassViewController.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 15/02/2021.
//

import UIKit
import SwiftUI

class BookClassViewController: UIViewController {

    private let gradientIV = GradientImageView()
    private let sideTextPadding: CGFloat = 25
    
    private let buttonAnimations = ButtonAnimations()
    
    private let classNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Yoga".uppercased()
        label.font = .helveticaNeue(ofSize: 29, weight: .medium)
        label.textColor = .energyOrange
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11:00am - 12:00pm"
        label.font = .helveticaNeue(ofSize: 14)
        label.textColor = .energyOrange
        return label
    }()
    
    private let descriptionText: UITextView = {
        let textView = UITextView()
        textView.text = """
        Yoga is an ancient form of exercise that focuses on
        strength, flexibility and breathing to boost physical
        and mental wellbeing. The main components of yoga
        """
        textView.font = .helveticaNeue(ofSize: 14)
        textView.textColor = .energyParagraphColor
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private let trainerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "zhgileva")
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    private let trainerLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Trainer", comment: "Trainer label")
        label.font = .helveticaNeue(ofSize: 14)
        label.textColor = .energyParagraphColor
        return label
    }()
    
    private let trainerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Жгилева Е."
        label.font = .helveticaNeue(ofSize: 14)
        label.textColor = .energyParagraphColor
        return label
    }()
    
    private lazy var bookButton: UIButton = {
        let button = UIButton()
        let buttonText = NSLocalizedString("Book", comment: "Book button label")
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = .helveticaNeue(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .energyOrange
        buttonAnimations.startAnimatingPressActions(for: button)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 14, right: 20)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .energyBackgroundColor
        configureUI()
    }

    deinit {
        print("Deinit on \(String(describing: self))")
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.addSubview(gradientIV)
        gradientIV.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          height: view.frame.height * 4/7)
        
        let infoView = UIView()
        view.addSubview(infoView)
        infoView.anchor(top: gradientIV.bottomAnchor, paddingTop: 5,
                        leading: view.leadingAnchor, paddingLeading: 25,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 25,
                        trailing: view.trailingAnchor, paddingTrailing: 25)
        
        setupElements(in: infoView)
    }
    
    private func setupElements(in infoContainer: UIView) {
        infoContainer.addSubview(classNameLabel)
        classNameLabel.anchor(top: infoContainer.topAnchor,
                              leading: infoContainer.leadingAnchor)
        
        infoContainer.addSubview(timeLabel)
        timeLabel.anchor(top: classNameLabel.bottomAnchor, paddingTop: 3,
                         leading: classNameLabel.leadingAnchor)
        
        infoContainer.addSubview(trainerImageView)
        trainerImageView.anchor(leading: classNameLabel.leadingAnchor,
                                bottom: infoContainer.bottomAnchor,
                                width: 55, height: 55)
        
        infoContainer.addSubview(descriptionText)
        descriptionText.anchor(top: timeLabel.bottomAnchor, paddingTop: 17,
                               leading: timeLabel.leadingAnchor,
                               bottom: trainerImageView.topAnchor, paddingBottom: 25,
                               trailing: infoContainer.trailingAnchor)
        
        
        infoContainer.addSubview(trainerLabel)
        trainerLabel.centerY(withView: trainerImageView, constant: -10)
        trainerLabel.anchor(leading: trainerImageView.trailingAnchor, paddingLeading: 7)
        
        infoContainer.addSubview(trainerNameLabel)
        trainerNameLabel.centerY(withView: trainerImageView, constant: 10)
        trainerNameLabel.anchor(leading: trainerLabel.leadingAnchor)
        
        infoContainer.addSubview(bookButton)
        bookButton.centerY(withView: trainerImageView)
        bookButton.anchor(trailing: infoContainer.trailingAnchor)
        
        infoContainer.layoutIfNeeded()
        trainerImageView.layer.cornerRadius = trainerImageView.frame.height / 2
        bookButton.layer.cornerRadius = bookButton.frame.height/2
    }
    
}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------------
struct BookClassViewControllerIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return BookClassViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct BookClassViewControllerPreviewController: View {
    var body: some View {
        BookClassViewControllerIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct BookClassViewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookClassViewControllerPreviewController()
                .previewDevice("iPhone X")
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "ru"))
            
            BookClassViewControllerPreviewController()
                .previewDevice("iPhone 8")
                .preferredColorScheme(.light)
        }
    }
}
