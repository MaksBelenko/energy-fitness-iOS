//
//  HeaderSchedule.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 23/02/2021.
//

import UIKit
import SwiftUI

protocol ScheduleHeaderCellProtocol: ReuseIdentifiable {
    var isLoading: Bool { get set }
    func setTimeLabelText(to text: String)
}

class ScheduleHeaderCell: UICollectionViewCell, ScheduleHeaderCellProtocol {
    
    var isLoading: Bool = true {
        didSet {
            shimmerView.isHidden = !isLoading
            timeLabel.isHidden = isLoading
        }
    }
    
    private lazy var shimmerView: ShimmerView = {
        let view = ShimmerView(gradientColour: .energyShimmerUnder, gradientFrame: self.bounds)
        view.backgroundColor = .energyShimmer
        return view
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.energyContainerColor.withAlphaComponent(0.7)
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "time here -"
        label.font = UIFont.helveticaNeue(ofSize: 18, weight: .medium)
        label.textColor = .energyOrange
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
        addSubview(bgView)
        bgView.contain(in: self)
        
        bgView.addSubview(timeLabel)
        timeLabel.anchor(leading: bgView.leadingAnchor, paddingLeading: 15)
        timeLabel.centerY(withView: bgView)
        
        addSubview(shimmerView)
        shimmerView.anchor(top: timeLabel.topAnchor, paddingTop: 5,
                                leading: timeLabel.leadingAnchor,
                                bottom: timeLabel.bottomAnchor,
                                width: 60)
    }
    
    
    // MARK: - Public methods
    func setTimeLabelText(to text: String) {
        timeLabel.text = text
    }
}








// MARK: - -------------- SWIFTUI PREVIEW HELPER --------------
struct HeaderSchedule_IntegratedCell: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        return ScheduleHeaderCell()
    }
}

struct HeaderSchedule_PreviewView: View {
    var body: some View {
        HeaderSchedule_IntegratedCell().edgesIgnoringSafeArea(.all)
    }
}

struct HeaderSchedule_Previews: PreviewProvider {
    
    
    static var previews: some View {
        Group {
            HeaderSchedule_PreviewView()
                .previewLayout(.fixed(width: 200, height: 50))
                .preferredColorScheme(.light)
        
            HeaderSchedule_PreviewView()
                .previewLayout(.fixed(width: 200, height: 50))
                .preferredColorScheme(.dark)
        }
    }
}
