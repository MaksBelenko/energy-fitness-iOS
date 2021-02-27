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
//    var classNameLabel: UILabel { get set }
//    var timeLabel: UILabel { get set }
//    var trainerImageView: UIImageView { get set }
//    var trainerNameLabel: UILabel { get set }
}

//extension ScheduleCell: ReuseIdentifiable {}

class ScheduleCell: UICollectionViewCell, ScheduleCellProtocol {
    
    private var viewModel: ScheduleCellViewModelProtocol!
    private var subscription: AnyCancellable!
    
    private var textShimmers = [UIView]()
    private var imageShimmers = [UIView]()
    
    private var textLabels = [UIView]()
    private var imageViews = [UIView]()
    
    var isTextLoading = true {
        didSet {
            textShimmers.forEach { $0.isHidden = !isTextLoading }
            textLabels.forEach { $0.isHidden = isTextLoading }
        }
    }
    
    var isImagesLoading = true {
        didSet {
            imageShimmers.forEach { $0.isHidden = !isTextLoading }
            imageViews.forEach { $0.isHidden = isTextLoading }
        }
    }
    
    // MARK: - Computed Views
    private let imageWidth: CGFloat = 27
    
    private var internalView: UIView = {
        let view = UIView()
        view.backgroundColor = .energyCellColour
        view.layer.cornerRadius = 16
        view.layer.applyShadow(color: .black, alpha: 0.16, x: 5, y: 5, blur: 10)
        return view
    }()
    
    private var classNameLabel: UILabel = {
        let label = UILabel()
        label.text = "CrossFit"
        label.font = UIFont.classNameHeader(ofSize: 20)
        label.textColor = .energyOrange
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11:00 am - 12:00 pm"
        label.font = UIFont.scheduleParagraph(ofSize: 14)
        label.textColor = .energyOrange
        return label
    }()
    
    private var trainerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "zhgileva")
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private var trainerNameLabel: UILabel = {
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
    
    deinit {
        Log.logDeinit(String(describing: self))
    }
    
    // MARK: - Set ViewModel
    
    func setViewModel(to viewModel: ScheduleCellViewModelProtocol) {
        self.viewModel = viewModel
        
        subscription = viewModel.isTextLoading
                            .assignOnUnowned(to: \.isTextLoading, on: self)
//            .store(in: &subscriptions)
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        
        addSubview(internalView)
        internalView.anchor(top: topAnchor,
                            leading: leadingAnchor, paddingLeading: 10,
                            bottom: bottomAnchor, paddingBottom: 10,
                            trailing: trailingAnchor, paddingTrailing: 10)
        
        configureElements(in: internalView)
        addShimmers()
        
        textLabels = [ classNameLabel, timeLabel, trainerNameLabel ]
        imageViews = [ trainerImageView ]
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
        trainerImageView.layer.cornerRadius = imageWidth / 2
        
        view.addSubview(trainerNameLabel)
        trainerNameLabel.centerY(withView: trainerImageView)
        trainerNameLabel.anchor(leading: trainerImageView.trailingAnchor, paddingLeading: 10)
        
        view.addSubview(chevronArrow)
        chevronArrow.anchor(trailing: view.trailingAnchor, paddingTrailing: 20,
                            width: 15, height: 20)
        chevronArrow.centerY(withView: view)
        
    }
    
    // MARK: - Shimmers
    private func addShimmers() {
        textShimmers = [
            addShimmerView(for: classNameLabel, width: 166, topOffset: 3),
            addShimmerView(for: timeLabel, width: 127, topOffset: 3),
            addShimmerView(for: trainerNameLabel, width: 93, topOffset: 3),
        ]
        
        let shimmerTrainerImageView = addShimmerView(for: trainerImageView)
        shimmerTrainerImageView.layer.cornerRadius = imageWidth/2
        
        imageShimmers = [ shimmerTrainerImageView ]
    }
    
    
    private func addShimmerView(for view: UIView, width: CGFloat? = nil, topOffset: CGFloat = 0) -> UIView {
        let shimmerView = ShimmerView(gradientColour: .energyShimmerUnder, gradientFrame: self.bounds)
        shimmerView.backgroundColor = .energyShimmer
        
        self.addSubview(shimmerView)
        shimmerView.anchor(top: view.topAnchor, paddingTop: topOffset,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor)
        
        if let width = width {
            shimmerView.anchor(width: width)
        } else {
            shimmerView.anchor(trailing: view.trailingAnchor)
        }
        
        return shimmerView
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
