//
//  NoSessionView.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/02/2021.
//

import UIKit
import SwiftUI

class NoSessionView: UIView {
    
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "nosessions")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .energyOrange
        label.font = .raleway(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = NSLocalizedString("No sessions", comment: "No session text")
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        addSubview(textLabel)
        textLabel.anchor(leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         height: 25)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: textLabel.topAnchor, paddingBottom: 6,
                         trailing: trailingAnchor)
    }
    
}







// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------------
struct NoSessionView_IntegratedController: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = NoSessionView()
        return view
    }
}

struct NoSessionView_PreviewView: View {
    var body: some View {
        NoSessionView_IntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct NoSessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NoSessionView_PreviewView()
                .previewLayout(.fixed(width: 250, height: 200))
                .preferredColorScheme(.light)
            
//            NoSessionView_PreviewView()
//                .previewLayout(.fixed(width: 250, height: 200))
//                .preferredColorScheme(.dark)
        }
    }
}
