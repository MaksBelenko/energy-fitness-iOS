//
//  ScheduleCellViewModel.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 26/02/2021.
//

import UIKit.UIImage
import Combine

protocol ScheduleCellViewModelProtocol {
    var isTextLoading: AnyPublisher<Bool, Never> { get }
}

class ScheduleCellViewModel: ScheduleCellViewModelProtocol {
    
    var isTextLoading: AnyPublisher<Bool, Never> {
        return isTextLoadingSubject.eraseToAnyPublisher()
    }
    
    private var isTextLoadingSubject = CurrentValueSubject<Bool, Never>(true)
    
    var gymClassName: String?
    var timePresented: String?
    var trainerName: String?
    var trainerImage: UIImage?
    
    
    deinit {
        Log.logDeinit("\(self)")
    }
    
    func setTextLoading(to value: Bool) {
        isTextLoadingSubject.send(value)
    }
}
