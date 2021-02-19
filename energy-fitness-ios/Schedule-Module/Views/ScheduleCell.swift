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
    
    private var internalView: UIView = {
        let view = UIView()
        view.backgroundColor = .energyCellColour
        view.layer.cornerRadius = 16
        view.layer.applyShadow(color: .black, alpha: 0.16, x: 5, y: 5, blur: 10)
        return view
    }()
    
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
    
    private var chevronArrow: UIImageView = {
        let iv = UIImageView()
        let image: UIImage = #imageLiteral(resourceName: "chevron").withTintColor(.energyDateDarkened)
        iv.image = image
        return iv
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .clear
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
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        addSubview(internalView)
        internalView.anchor(top: topAnchor,
                            leading: leadingAnchor, paddingLeading: 10,
                            bottom: bottomAnchor, paddingBottom: 10,
                            trailing: trailingAnchor, paddingTrailing: 10)
        
        configureElements(in: internalView)
    }
    
    
    private func configureElements(in view: UIView) {
        view.addSubview(classNameLabel)
        classNameLabel.anchor(top: view.topAnchor, paddingTop: 7,
                              leading: view.leadingAnchor, paddingLeading: 19)
        
        view.addSubview(timeLabel)
        timeLabel.anchor(top: classNameLabel.bottomAnchor, paddingTop: 0,
                         leading: classNameLabel.leadingAnchor)
       
        view.addSubview(trainerImageView)
        trainerImageView.anchor(top: timeLabel.bottomAnchor, paddingTop: 9,
                                leading: classNameLabel.leadingAnchor,
                                width: 27, height: 27)
        
        view.addSubview(trainerNameLabel)
        trainerNameLabel.centerY(withView: trainerImageView)
        trainerNameLabel.anchor(leading: trainerImageView.trailingAnchor, paddingLeading: 10)
        
        layoutIfNeeded()
        trainerImageView.layer.masksToBounds = true
        trainerImageView.layer.cornerRadius = trainerImageView.frame.height / 2
        
        view.addSubview(chevronArrow)
        chevronArrow.anchor(trailing: view.trailingAnchor, paddingTrailing: 20,
                            width: 15, height: 20)
        chevronArrow.centerY(withView: view)
    }
    
    // MARK: - Configure Gestures
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.transform = CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchesEnded(touches, with: event)
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
                .previewLayout(.fixed(width: 346, height: 100))
                .preferredColorScheme(.light)
        
            ScheduleCell_PreviewView()
                .previewLayout(.fixed(width: 346, height: 100))
                .preferredColorScheme(.dark)
        }
    }
}
