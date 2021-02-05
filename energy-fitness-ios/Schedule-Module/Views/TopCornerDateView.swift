//
//  TopCornerDateView.swift
//  energy-fitness-ios
//
//  Created by Maksim on 02/02/2021.
//

import UIKit
import SwiftUI

class TopCornerDateView: UIView {

    let weekdayFactory = WeekDayFactory()
    let monthFactory = MonthFactory()
    
    private let dateToTextSpacing: CGFloat = 5
    
    private var dateNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "24"
        label.font = UIFont.topCornerDateFont(ofSize: 44)
        label.textColor = .energyCalendarDateColour
        return label
    }()
    
    private var weekdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Wed"
        label.font = UIFont.topCornerDateFont(ofSize: 13)
        label.textColor = .energyDateDarkened
        return label
    }()
    
    private var monthYearLabel: UILabel = {
        let label = UILabel()
        label.text = "Jan 2020"
        label.font = UIFont.topCornerDateFont(ofSize: 13)
        label.textColor = .energyDateDarkened
        return label
    }()
    
    // MARK: - Initialisation
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        layoutSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Intrinsic size for the UIView
    override var intrinsicContentSize: CGSize {
        layoutSubviews() // adjust to get layout width and height
        let viewHeight = dateNumberLabel.frame.height
        let viewWidth = dateNumberLabel.frame.width + dateToTextSpacing + monthYearLabel.frame.width
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        addSubview(dateNumberLabel)
        dateNumberLabel.anchor(top: topAnchor, leading: leadingAnchor)
        
        addSubview(weekdayLabel)
        weekdayLabel.anchor(top: dateNumberLabel.topAnchor, paddingTop: 7,
                            leading: dateNumberLabel.trailingAnchor, paddingLeading: dateToTextSpacing)
        
        addSubview(monthYearLabel)
        monthYearLabel.anchor(leading: dateNumberLabel.trailingAnchor, paddingLeading: dateToTextSpacing,
                              bottom: dateNumberLabel.bottomAnchor, paddingBottom: 7)
    }
    
    // MARK: - Set date to be shown
    func setDateToBeShown(date: Date) {
        let dateComp = date.get(.day, .weekday, .month, .year)
        
        dateNumberLabel.text = String(dateComp.day!)
        weekdayLabel.text = String(weekdayFactory.create(from: dateComp.weekday!)!.getLocalisedString(format: .Short))
        
        let monthShortName = monthFactory.create(from: dateComp.month!)!.getLocalisedName(format: .ThreeLetters)
        let year = dateComp.year!
        monthYearLabel.text = "\(monthShortName) \(year)"
    }

}



// -------------- SWIFTUI PREVIEW HELPER --------------------
struct TopCornerDateView_IntegratedController: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = TopCornerDateView()
        view.setDateToBeShown(date: Date())
        return view
    }
}

struct TopCornerDateView_PreviewView: View {
    var body: some View {
        TopCornerDateView_IntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct TopCornerDateView__Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TopCornerDateView_PreviewView()
                .previewLayout(.fixed(width: 200, height: 100))
                .preferredColorScheme(.light)
            
            TopCornerDateView_PreviewView()
                .previewLayout(.fixed(width: 200, height: 100))
                .preferredColorScheme(.dark)
        }
    }
}
