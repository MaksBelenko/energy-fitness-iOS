//
//  FillTextField.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 19/03/2021.
//

import UIKit.UITextField
import SwiftUI

class FillTextField: UITextField {
    
    private(set) var isPlaceholderHidden = false
    
    var smallPlaceHolderBackgroundColour = UIColor.clear {
        didSet { smallPlaceholderLabel.backgroundColor = smallPlaceHolderBackgroundColour }
    }
    
    var placeholderColor: UIColor = .gray {
        didSet { setPlaceholderColor(to: placeholderColor) }
    }

    var smallPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet { smallPlaceholderLabel.font = smallPlaceholderFont }
    }
    
    var smallPlaceholderText: String = " " {
        didSet { smallPlaceholderLabel.text = smallPlaceholderText }
    }
    
    var smallPlaceholderColor: UIColor = .lightGray {
        didSet { smallPlaceholderLabel.textColor = smallPlaceholderColor }
    }
    
    private let smallPlaceholderLeftOffset: CGFloat = 9
    private let placeholderLeftOffset: CGFloat = 13
    
    
    // MARK: - Views
    
    private lazy var smallPlaceholderLabel: PaddedLabel = {
        let label = PaddedLabel(top: 0, bottom: 0, left: 5, right: 5)
        label.font = smallPlaceholderFont
        label.textColor = smallPlaceholderColor
        return label
    }()
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupObservers()
        changeSmallPlaceholderState(to: .hide)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing),
                                               name: UITextField.textDidEndEditingNotification,
                                               object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidBeginEditing),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: self)
    }
    
    // MARK: - Offsets
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: placeholderLeftOffset , dy: 0)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: placeholderLeftOffset , dy: 0)
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        clipsToBounds = false
        setPlaceholderColor(to: placeholderColor)
        
        smallPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(smallPlaceholderLabel)
        NSLayoutConstraint.activate([
            smallPlaceholderLabel.centerYAnchor.constraint(equalTo: self.topAnchor, constant: -1),
            smallPlaceholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: smallPlaceholderLeftOffset)
        ])
        smallPlaceholderLabel.clipsToBounds = true
        smallPlaceholderLabel.layer.cornerRadius = 3
    }
    
    // MARK: - TextField Editing Observer
    
    @objc func textFieldTextDidEndEditing(notification : NSNotification) {
        guard let text = text else { return }
        if text.isEmpty {
            changeSmallPlaceholderState(to: .hide)
            setPlaceholderColor(to: placeholderColor)
        }
    }
    
    @objc func textFieldTextDidBeginEditing(notification : NSNotification) {
        changeSmallPlaceholderState(to: .show)
        setPlaceholderColor(to: .clear)
    }
    
    // MARK: - Animations
    
    private enum SmallPlaceholderState {
        case show, hide
    }
    
    
    private func changeSmallPlaceholderState(to state: SmallPlaceholderState) {
        isPlaceholderHidden = !isPlaceholderHidden
        let transform: CGAffineTransform = (state == .show) ? .identity
            : CGAffineTransform(translationX: 0, y: smallPlaceholderLabel.frame.height)
        
        let alpha: CGFloat = (state == .show) ? 1 : 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.smallPlaceholderLabel.transform = transform
            self.smallPlaceholderLabel.alpha = alpha
        })
    }
    
    // MARK: - Helpers
    private func setPlaceholderColor(to colour: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder ?? " ",
                                                   attributes: [NSAttributedString.Key.foregroundColor: colour])
    }
}









// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct FillTextField_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = FillTextField()
        let view = UIView()
        view.addSubview(textField)
        textField.anchor(top: view.topAnchor, paddingTop: 10,
                         leading: view.leadingAnchor, paddingLeading: 10,
                         bottom: view.bottomAnchor, paddingBottom: 10,
                         trailing: view.trailingAnchor, paddingTrailing: 10)
        return view
    }
}

struct FillTextField_PreviewView: View {
    var body: some View {
        FillTextField_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct FillTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FillTextField_PreviewView()
                .previewLayout(.fixed(width: 350, height: 70))
                .preferredColorScheme(.light)
            
            FillTextField_PreviewView()
                .previewLayout(.fixed(width: 350, height: 70))
                .preferredColorScheme(.dark)
        }
    }
}
