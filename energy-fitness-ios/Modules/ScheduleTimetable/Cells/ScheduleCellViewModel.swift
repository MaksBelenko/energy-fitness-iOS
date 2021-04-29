//
//  ScheduleCellViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/02/2021.
//

import UIKit.UIImage
import Combine
import Nuke
import ImagePublisher

protocol ScheduleCellViewModelProtocol {
    func getGymClassName() -> AnyPublisher<String, Never>
    func getTime() -> AnyPublisher<String, Never>
    func getTrainerName() -> AnyPublisher<String, Never>
    func getTrainerImage() -> AnyPublisher<UIImage, Never>
}

final class ScheduleCellViewModel: ScheduleCellViewModelProtocol {
    private let imagePipeline = Nuke.ImagePipeline.shared
    
    private var gymSessionSubject = CurrentValueSubject<GymSessionDto?, Never>(nil)
    private var trainerInitials: String!
    private var trainerInitialsImage: UIImage  {
        get { return ImageGenerator().generateProfileImage(initials: trainerInitials) }
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    init(gymSession: GymSessionDto) {
        gymSessionSubject.send(gymSession)
        trainerInitials = gymSession.trainer.getInitials()
    }
    
    // MARK: - Public publishers
    func getGymClassName() -> AnyPublisher<String, Never> {
        return gymSessionSubject
            .unwrap()
            .map(\.gymClass.name)
            .eraseToAnyPublisher()
    }
    
    func getTime() -> AnyPublisher<String, Never> {
        return gymSessionSubject
            .unwrap()
            .map { TimePeriodFormatter().getTimePeriod(from: $0.startDate, durationMins: $0.durationMins) }
            .eraseToAnyPublisher()
    }
    
    func getTrainerName() -> AnyPublisher<String, Never> {
        return gymSessionSubject
            .unwrap()
            .map { $0.trainer.getSurnameWithFirstNameLetter() }
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
