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
    var trainerImageUrl: CurrentValueSubject<String?, Never> { get set }
    var trainerImage: CurrentValueSubject<UIImage?, Never> { get set }
}


final class ScheduleCellViewModel: ScheduleCellViewModelProtocol {
//    var isTextLoading: AnyPublisher<Bool, Never> {
//        return isTextLoadingSubject.eraseToAnyPublisher()
//    }

//    private var isTextLoadingSubject = CurrentValueSubject<Bool, Never>(true)
    
    
    private var subscriptions = Set<AnyCancellable>()
    private static let imagePipeline = Nuke.ImagePipeline.shared
    
    var gymClassName = CurrentValueSubject<String, Never>("")
    var timePresented = CurrentValueSubject<String, Never>("")
    var trainerName = CurrentValueSubject<String, Never>("")
    var trainerImageUrl = CurrentValueSubject<String?, Never>(nil)
    var trainerImage = CurrentValueSubject<UIImage?, Never>(nil)
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    init() {
        let this = ScheduleCellViewModel.self
        
        trainerImageUrl
            .receive(on: DispatchQueue.main)
            .compactMap { $0?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) }
            .compactMap { URL(string: $0)?.asImageRequest() }
            .setFailureType(to: ImagePipeline.Error.self) // this is required for iOS 13
            .flatMap { imageRequest in
                this.imagePipeline.imagePublisher(with: imageRequest)
                    .eraseToAnyPublisher()
            }
            .map { $0.image }
            .sink(receiveCompletion: { completion in },
                  receiveValue: { [weak self] image in
                        self?.trainerImage.value = image
                  })
            .store(in: &subscriptions)
        
    }
    
//    func setTextLoading(to value: Bool) {
//        isTextLoadingSubject.send(value)
//    }
}
