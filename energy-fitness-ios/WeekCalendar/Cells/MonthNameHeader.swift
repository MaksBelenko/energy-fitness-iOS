//
//  MonthNameHeader.swift
//  WeekCalendar
//
//  Created by Maksim on 03/02/2021.
//  Copyright © 2021 Maksim Belenko. All rights reserved.
//

import UIKit
import SwiftUI

protocol MonthNameHeaderProtocol: UICollectionViewCell {
    var monthNameLabel: UILabel { get set }
}

class MonthNameHeader: UICollectionViewCell {
    static let identifier = "MonthNameHeader"
    
    var monthNameLabel: UILabel = {
        let label = UILabel()
        label.text = "February"
        label.font = UIFont.calendarDateFont(ofSize: 18)
        label.textColor = .energyDateDarkened
        return label
    }()
    
    
    // MARK: - Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        addSubview(monthNameLabel)
        monthNameLabel.centerY(withView: self)
        monthNameLabel.anchor(leading: leadingAnchor)
    }
}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct MonthNameHeader_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        return MonthNameHeader()
    }
}

struct MonthNameHeader_PreviewView: View {
    var body: some View {
        MonthNameHeader_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct MonthNameHeader_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            MonthNameHeader_PreviewView()
                .previewLayout(.fixed(width: 200, height: 50))
                .preferredColorScheme(.light)
        
            MonthNameHeader_PreviewView()
                .previewLayout(.fixed(width: 200, height: 50))
                .preferredColorScheme(.dark)
        }
    }
}
