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
    var trainerImage: CurrentValueSubject<UIImage?, Never> { get set }
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
    var trainerImage = CurrentValueSubject<UIImage?, Never>(nil)
    
    private let gymSession: GymSessionDto
    
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    init(gymSession: GymSessionDto) {
        self.gymSession = gymSession
        createBindings()
        
        gymClassName.value = gymSession.gymClass.name
        timePresented.value = TimePeriodFormatter().getTimePeriod(from: gymSession.startDate, durationMins: gymSession.durationMins)
        trainerName.value = gymSession.trainer.surname
        if let trainerPhoto = gymSession.trainer.photos.first {
            trainerImageUrl.value = "http://localhost:3000/api/trainers/image/download/1" + trainerPhoto.small
        }
    }
    
    private func createBindings() {
        
        trainerImageUrl
            .unwrap()
            .mapToURL()
            .setFailureType(to: ImagePipeline.Error.self) // for iOS 13
            .flatMap { [weak self] imageRequest -> AnyPublisher<ImageResponse, ImagePipeline.Error> in
                guard let imagePublisher = self?.imagePipeline.imagePublisher(with: imageRequest) else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                return imagePublisher.eraseToAnyPublisher()
            }
            .map { $0.image }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in print("Completed") },
                  receiveValue: { [weak self] image in
                        self?.trainerImage.value = image
                  })
            .store(in: &subscriptions)
    }
    
//    func setTextLoading(to value: Bool) {
//        isTextLoadingSubject.send(value)
//    }
}
