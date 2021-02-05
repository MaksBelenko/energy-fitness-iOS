//
//  ScheduleCell.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit
import SwiftUI

protocol ScheduleCellProtocol: UICollectionViewCell, ReuseIdentifiable {
    var classNameLabel: UILabel { get set }
    var timeLabel: UILabel { get set }
    var trainerImageView: UIImageView { get set }
    var trainerNameLabel: UILabel { get set }
}

//extension ScheduleCell: ReuseIdentifiable {}

class ScheduleCell: UICollectionViewCell, ScheduleCellProtocol {
    
    var classNameLabel: UILabel = {
        let label = UILabel()
        label.text = "CrossFit"
        label.font = UIFont.classNameHeader(ofSize: 20)
        label.textColor = .energyOrange
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11:00 am - 12:00 pm"
        label.font = UIFont.scheduleParagraph(ofSize: 14)
        label.textColor = .energyOrange
        return label
    }()
    
    var trainerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "personal_trainer_colour")
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var trainerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Жгилева E."
        label.font = UIFont.scheduleParagraph(ofSize: 13)
        label.textColor = .energyScheduleTrainerName
        return label
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .energyCellColour
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func willMove(toWindow newWindow: UIWindow?) {
//        super.willMove(toWindow: newWindow)
//
//        if newWindow == nil {
//            // UIView disappear
//        } else {
//            // UIView appear
//        }
//    }
    
//    override func layoutSubviews() {
//        cornerRadius(16)
//        applyShadow(color: .black, alpha: 0.16, x: 5, y: 5, blur: 10)
//    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        addSubview(classNameLabel)
        classNameLabel.anchor(top: topAnchor, paddingTop: 7,
                              leading: leadingAnchor, paddingLeading: 19)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: classNameLabel.bottomAnchor, paddingTop: 0,
                         leading: classNameLabel.leadingAnchor)
       
        addSubview(trainerImageView)
        trainerImageView.anchor(top: timeLabel.bottomAnchor, paddingTop: 9,
                                leading: classNameLabel.leadingAnchor,
                                width: 27, height: 27)
        
        layoutIfNeeded()
        trainerImageView.layer.masksToBounds = true
        trainerImageView.layer.cornerRadius = trainerImageView.frame.height / 2
        
        addSubview(trainerNameLabel)
        trainerNameLabel.centerY(withView: trainerImageView)
        trainerNameLabel.anchor(leading: trainerImageView.trailingAnchor, paddingLeading: 10)
    }
}


// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct ScheduleCell_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        return ScheduleCell()
    }
}

struct ScheduleCell_PreviewView: View {
    var body: some View {
        ScheduleCell_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct ScheduleCell_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            ScheduleCell_PreviewView()
                .previewLayout(.fixed(width: 346, height: 90))
                .preferredColorScheme(.light)
        
            ScheduleCell_PreviewView()
                .previewLayout(.fixed(width: 346, height: 90))
                .preferredColorScheme(.dark)
        }
    }
}
