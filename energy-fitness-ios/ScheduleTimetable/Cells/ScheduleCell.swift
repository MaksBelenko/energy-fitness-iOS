//
//  ScheduleCell.swift
//  energy-fitness-ios
//
//  Created by Maksim on 04/02/2021.
//

import UIKit
import SwiftUI
import Combine

protocol ScheduleCellProtocol: UICollectionViewCell, ReuseIdentifiable {
}

final class ScheduleCell: UICollectionViewCell, ScheduleCellProtocol {
    
    private var viewModel: ScheduleCellViewModelProtocol!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Computed Views
    private let imageWidth: CGFloat = 27
    private let internalViewCornerRadius: CGFloat = 16
    
    private lazy var internalView: UIView = {
        let view = UIView()
        view.backgroundColor = .energyCellColour
        view.layer.cornerRadius = internalViewCornerRadius
        return view
    }()
    
    private lazy var classNameLabel: Shimmered<UILabel> = {
        let label = Shimmered<UILabel>()
        label.configureShimmer(gradientFrame: self.bounds, width: 166, topOffset: 3)
        label.view.text = " "
        label.view.font = UIFont.classNameHeader(ofSize: 20)
        label.view.textColor = .energyOrange
        return label
    }()
    
    private lazy var timeLabel: Shimmered<UILabel> = {
        let label = Shimmered<UILabel>()
        label.configureShimmer(gradientFrame: self.bounds, width: 127, topOffset: 3)
        label.view.text = " "
        label.view.font = UIFont.scheduleParagraph(ofSize: 14)
        label.view.textColor = .energyOrange
        return label
    }()
    
    private lazy var trainerNameLabel: Shimmered<UILabel> = {
        let label = Shimmered<UILabel>()
        label.configureShimmer(gradientFrame: self.bounds, width: 93, topOffset: 3)
        label.view.text = " "
        label.view.font = UIFont.scheduleParagraph(ofSize: 13)
        label.view.textColor = .energyScheduleTrainerName
        return label
    }()

    private lazy var trainerImageView: Shimmered<UIImageView> = {
        let iv = Shimmered<UIImageView>()
        iv.view.image = #imageLiteral(resourceName: "zhgileva")
        iv.view.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = imageWidth/2
        iv.configureShimmer(gradientFrame: self.bounds)
        return iv
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
        layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        internalView.layer.applyShadow(rect: internalView.bounds, cornerRadius: internalViewCornerRadius, color: .black, alpha: 0.16, x: 5, y: 5, blur: 10)
    }
    
    
    // MARK: - Set ViewModel
    func setViewModel(to viewModel: ScheduleCellViewModelProtocol) {
        self.viewModel = viewModel
        createBindings()
    }
    
    private func createBindings() {
        viewModel.trainerName
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] name in
                if name != "" {
                    self.trainerNameLabel.view.text = name
                    self.trainerNameLabel.shimmer?.stopAndHide()
                }
            })
            .store(in: &subscriptions)
        
        viewModel.trainerImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned trainerImageView] image in
                trainerImageView.view.image = image
                trainerImageView.shimmer?.stopAndHide()
            })
            .store(in: &subscriptions)
        
        
        viewModel.gymClassName
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] name in
                if name != "" {
                    self.classNameLabel.view.text = name
                    self.classNameLabel.shimmer?.stopAndHide()
                }
            })
            .store(in: &subscriptions)
        
        
        viewModel.timePresented
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] timeString in
                if timeString != "" {
                    self.timeLabel.view.text = timeString
                    self.timeLabel.shimmer?.stopAndHide()
                }
            })
            .store(in: &subscriptions)
    }
    
    
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
                                width: imageWidth, height: imageWidth)
        
        view.addSubview(trainerNameLabel)
        trainerNameLabel.centerY(withView: trainerImageView)
        trainerNameLabel.anchor(leading: trainerImageView.trailingAnchor, paddingLeading: 10)
        
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
