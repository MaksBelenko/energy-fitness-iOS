//
//  BookViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 15/03/2021.
//

import UIKit.UIImage
import Combine
import Nuke
import ImagePublisher

final class BookViewModel {
    
    var gymClassName = PassthroughSubject<String, Never>()
    var gymClassDescription = PassthroughSubject<String, Never>()
    var sessionTime = PassthroughSubject<String, Never>()
    var trainerName = PassthroughSubject<String, Never>()
    var trainerImage = PassthroughSubject<UIImage, Never>()
    var gymClassImage = PassthroughSubject<UIImage, Never>()
    
    private let timeFormatter: TimePeriodFormatter
    
    private var trainerInitials: String = "?"
    private lazy var trainerInitialsImage: UIImage = {
        let imageGenerator = ImageGenerator()
        return imageGenerator.generateProfileImage(initials: trainerInitials)
    }()
    
    private var gymClassImageURL = PassthroughSubject<String, Never>()
    private var trainerImageURL = PassthroughSubject<String, Never>()
    
    private let imagePipeline = Nuke.ImagePipeline.shared
    private var subscriptions = Set<AnyCancellable>()
    
    private let defaultImage = UIImage(named: "ENERGY-black")!
    
    // MARK: - Initialisation
    init(timeFormatter: TimePeriodFormatter) {
        self.timeFormatter = timeFormatter
        setupBindings()
    }
    
    
    func setViewModel(with gymSession: GymSessionDto) {
        trainerInitials = gymSession.trainer.getInitials()
        
        gymClassName.send(gymSession.gymClass.name)
        gymClassDescription.send(gymSession.gymClass.description)
        sessionTime.send(timeFormatter.getTimePeriod(from: gymSession.startDate, durationMins: gymSession.durationMins))
        trainerName.send(gymSession.trainer.getSurnameWithFirstNameLetter())
        
        if let largeGymClassImageName = gymSession.gymClass.photos.first?.large {
            let urlString = "http://localhost:3000/api/gym-classes/image/download/" + largeGymClassImageName
            gymClassImageURL.send(urlString)
        } else {
            gymClassImage.send(defaultImage)
        }
        
        if let largeTrainerImageName = gymSession.trainer.photos.first?.large {
            let urlString = "http://localhost:3000/api/trainers/image/download/" + largeTrainerImageName
            trainerImageURL.send(urlString)
        } else {
            trainerImage.send(trainerInitialsImage)
        }
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        gymClassImageURL
            .mapToURL()
            .setFailureType(to: ImagePipeline.Error.self) // for iOS 13
            .flatMap(imagePipeline.imagePublisher)
            .map { $0.image }
            .replaceError(with: defaultImage)
            .sink { [weak self] image in
                    self?.gymClassImage.send(image)
            }
            .store(in: &subscriptions)
        
        trainerImageURL
            .mapToURL()
            .setFailureType(to: ImagePipeline.Error.self) // for iOS 13
            .flatMap(imagePipeline.imagePublisher)
            .map { $0.image }
            .replaceError(with: trainerInitialsImage)
            .sink { [weak self] image in
                self?.trainerImage.send(image)
            }
            .store(in: &subscriptions)
            
    }
}

