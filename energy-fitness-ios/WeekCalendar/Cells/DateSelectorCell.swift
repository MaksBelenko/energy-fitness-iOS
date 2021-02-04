//
//  DateSelectorCell.swift
//  WeekCalendar
//
//  Created by Maksim on 03/02/2021.
//  Copyright © 2021 Maksim Belenko. All rights reserved.
//

import UIKit
import SwiftUI

protocol DateCellProtocol: UICollectionViewCell {
    var weekDayLabel: UILabel { get set }
    var dayLabel: UILabel { get set }
    func selectCell(_ selected: Bool, animated: Bool)
    
}

class DateSelectorCell: UICollectionViewCell, DateCellProtocol {
 
    static let identifier = "DateSelectorCell"
    
    private let selectAnimationDuration: TimeInterval = 0.25 //seconds
    
    var weekDayLabel: UILabel = {
        let label = UILabel()
        label.text = "W"
        label.font = UIFont.calendarDateFont(ofSize: 13)
        label.textColor = .energyDateDarkened
        return label
    }()
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.font = UIFont.calendarDateFont(ofSize: 18)
        label.textColor = .energyCalendarDateColour
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
        self.layer.cornerRadius = self.frame.height/8
        
        addSubview(weekDayLabel)
        weekDayLabel.anchor(top: topAnchor, paddingTop: 7)
        weekDayLabel.centerX(withView: self)
        
        addSubview(dayLabel)
        dayLabel.anchor(bottom: bottomAnchor, paddingBottom: 6)
        dayLabel.centerX(withView: self)
    }
    
    
    // MARK: - Cell Selection
    
    func selectCell(_ selected: Bool, animated: Bool = true) {
        let newBgColor: UIColor = (selected) ? .energyOrange : .clear
        let newDateNumberColor: UIColor = (selected) ? .white : .energyCalendarDateColour
        let newWeekdayColor: UIColor = (selected) ? .white : .energyDateDarkened
        
        if (animated == true) {
            UIView.animate(withDuration: selectAnimationDuration) { [weak self] in
                self?.backgroundColor = newBgColor
            }
            transitionColor(for: weekDayLabel, to: newWeekdayColor)
            transitionColor(for: dayLabel, to: newDateNumberColor)
        } else {
            self.backgroundColor = newBgColor
            self.weekDayLabel.textColor = newWeekdayColor
            self.dayLabel.textColor = newDateNumberColor
        }
    }
    
    private func transitionColor(for label: UILabel, to newColor: UIColor, options: AnimationOptions = .transitionCrossDissolve) {
        UIView.transition(with: label, duration: selectAnimationDuration, options: .transitionCrossDissolve, animations: {
            label.textColor = newColor
        }, completion: nil)
    }
}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct DateSelectorCell_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        return DateSelectorCell()
    }
}

struct DateSelectorCell_PreviewView: View {
    var body: some View {
        DateSelectorCell_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct DateSelectorCell_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            DateSelectorCell_PreviewView()
                .previewLayout(.fixed(width: 45, height: 51))
                .preferredColorScheme(.light)
        
            DateSelectorCell_PreviewView()
                .previewLayout(.fixed(width: 45, height: 51))
                .preferredColorScheme(.dark)
        }
    }
}

