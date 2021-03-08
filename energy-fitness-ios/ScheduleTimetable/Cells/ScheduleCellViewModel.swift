//
//  ScheduleCellViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/02/2021.
//

import UIKit.UIImage
import Combine

protocol ScheduleCellViewModelProtocol {
    var gymClassName: CurrentValueSubject<String, Never> { get set }
    var timePresented: CurrentValueSubject<String, Never> { get set }
    var trainerName: CurrentValueSubject<String, Never> { get set }
    var trainerImage: CurrentValueSubject<UIImage?, Never> { get set }
}


class ScheduleCellViewModel: ScheduleCellViewModelProtocol {
//    var isTextLoading: AnyPublisher<Bool, Never> {
//        return isTextLoadingSubject.eraseToAnyPublisher()
//    }

//    private var isTextLoadingSubject = CurrentValueSubject<Bool, Never>(true)
    
    var gymClassName = CurrentValueSubject<String, Never>("")
    var timePresented = CurrentValueSubject<String, Never>("")
    var trainerName = CurrentValueSubject<String, Never>("")
    var trainerImage = CurrentValueSubject<UIImage?, Never>(nil)
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
//    func setTextLoading(to value: Bool) {
//        isTextLoadingSubject.send(value)
//    }
}
