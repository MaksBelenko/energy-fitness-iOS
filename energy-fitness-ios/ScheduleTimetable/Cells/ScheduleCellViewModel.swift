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
    var gymClassName: CurrentValueSubject<String, Never> { get set }
    var timePresented: CurrentValueSubject<String, Never> { get set }
    var trainerName: CurrentValueSubject<String, Never> { get set }
    var trainerImage: PassthroughSubject<UIImage, Never> { get set }
}


final class ScheduleCellViewModel: ScheduleCellViewModelProtocol {
//    var isTextLoading: AnyPublisher<Bool, Never> {
//        return isTextLoadingSubject.eraseToAnyPublisher()
//    }

//    private var isTextLoadingSubject = CurrentValueSubject<Bool, Never>(true)
    
    
    private var subscriptions = Set<AnyCancellable>()
    private let imagePipeline = Nuke.ImagePipeline.shared
    
    var gymClassName = CurrentValueSubject<String, Never>("")
    var timePresented = CurrentValueSubject<String, Never>("")
    var trainerName = CurrentValueSubject<String, Never>("")
    var trainerImageUrl = CurrentValueSubject<String?, Never>(nil)
    var trainerImage = PassthroughSubject<UIImage, Never>()
    
    private let trainerInitials: String
    private let gymSession: GymSessionDto
    
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    init(gymSession: GymSessionDto) {
        self.gymSession = gymSession
        let trainerForename = gymSession.trainer.forename
        let trainerSurname = gymSession.trainer.surname
        trainerInitials = (trainerForename.first?.uppercased() ?? "-") + (trainerSurname.first?.uppercased() ?? "-")
        
        createBindings()
        
        trainerName.value = "\(trainerForename.first?.uppercased() ?? "-"). \(trainerSurname)"
        gymClassName.value = gymSession.gymClass.name
        timePresented.value = TimePeriodFormatter().getTimePeriod(from: gymSession.startDate, durationMins: gymSession.durationMins)
        if let trainerPhoto = gymSession.trainer.photos.first {
            trainerImageUrl.value = "http://localhost:3000/api/trainers/image/download/" + trainerPhoto.small
        }
    }
    
    private func createBindings() {
        
        trainerImageUrl
            .unwrap()
            .mapToURL()
            .setFailureType(to: ImagePipeline.Error.self) // for iOS 13
            .flatMap(imagePipeline.imagePublisher)
            .map { $0.image }
            .replaceError(with: ProfileImageGenerator().generateProfileImage(initials: trainerInitials))
            .sink(receiveCompletion: { completion in print("Completed") },
                  receiveValue: { [weak self] image in
                        self?.trainerImage.send(image)
                  })
            .store(in: &subscriptions)
    }
}
