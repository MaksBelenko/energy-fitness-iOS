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
    
    private(set) var gymSessionSubject = PassthroughSubject<GymSessionDto?, Never>()
    
    private let timeFormatter: TimePeriodFormatter
    
    private var trainerInitials: String = "?"
    private lazy var trainerInitialsImage: UIImage = {
        let imageGenerator = ImageGenerator()
        return imageGenerator.generateProfileImage(initials: trainerInitials)
    }()
    
    private let defaultImage = UIImage(named: "ENERGY-black")!
    private let imagePipeline = Nuke.ImagePipeline.shared
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialisation
    init(timeFormatter: TimePeriodFormatter) {
        self.timeFormatter = timeFormatter
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    
    func setViewModel(with gymSession: GymSessionDto) {
        trainerInitials = gymSession.trainer.getInitials()
        gymSessionSubject.send(gymSession)
    }
    
    
    func getGymClassName() -> AnyPublisher<String, Never> {
        return gymSessionSubject
            .unwrap()
            .map(\.gymClass.name)
            .eraseToAnyPublisher()
    }
    
    func getGymClassDescription() -> AnyPublisher<String, Never> {
        return gymSessionSubject
            .unwrap()
            .map(\.gymClass.description)
            .eraseToAnyPublisher()
    }
    
    func getSessionTime() -> AnyPublisher<String, Never> {
        return gymSessionSubject
            .unwrap()
            .compactMap { [weak timeFormatter] gs in
                return timeFormatter?.getTimePeriod(from: gs.startDate, durationMins: gs.durationMins)
            }
            .eraseToAnyPublisher()
    }
    
    func getShortenTrainerName() -> AnyPublisher<String, Never> {
        return gymSessionSubject
            .unwrap()
            .map { $0.trainer.getSurnameWithFirstNameLetter() }
            .eraseToAnyPublisher()
    }
    
    func getGymClassImage() -> AnyPublisher<UIImage, Never> {
        return gymSessionSubject
            .map { $0?.gymClass.photos.first?.large }
            .flatMap { [imagePipeline, defaultImage] imageName -> AnyPublisher<UIImage, Never> in
                guard let imageName = imageName else {
                    return Just(defaultImage)
                        .eraseToAnyPublisher()
                }
                
                return Just(imageName)
                    .map { EnergyEndpoint.gymClassImage($0).url }
                    .setFailureType(to: ImagePipeline.Error.self) // for iOS 13
                    .flatMap(imagePipeline.imagePublisher)
                    .map { $0.image }
                    .replaceError(with: defaultImage)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getTrainerImage() -> AnyPublisher<UIImage, Never> {
        return gymSessionSubject
            .map { $0?.trainer.photos.first?.small }
            .flatMap { [imagePipeline, trainerInitialsImage] imageName -> AnyPublisher<UIImage, Never> in
                guard let imageName = imageName else {
                    return Just(trainerInitialsImage)
                        .eraseToAnyPublisher()
                }
                
                return Just(imageName)
                    .map { EnergyEndpoint.trainerImageDownload($0).url }
                    .setFailureType(to: ImagePipeline.Error.self) // for iOS 13
                    .flatMap(imagePipeline.imagePublisher)
                    .map { $0.image }
                    .replaceError(with: trainerInitialsImage)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

