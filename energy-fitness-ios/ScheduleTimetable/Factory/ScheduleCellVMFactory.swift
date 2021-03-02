//
//  ScheduleCellVMFactory.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 27/02/2021.
//

import UIKit.UIImage

protocol ScheduleCellVMFactoryProtocol {
    func createScheduleCellViewModel() -> ScheduleCellViewModelProtocol
    func createHeaderCellViewModel() -> ScheduleHeaderCellProtocol
}


struct GymClassTextData {
    let gymClassName: String
    let timePresented: String
    let trainerName: String
}

class ScheduleCellVMFactory: ScheduleCellVMFactoryProtocol {
    
    func createScheduleCellViewModel() -> ScheduleCellViewModelProtocol {
        return ScheduleCellViewModel()
        
//        if let textData = textData {
//            vm.gymClassName = textData.gymClassName
//            vm.timePresented = textData.timePresented
//            vm.trainerName = textData.trainerName
//        } else {
////            vm.setTextLoading(to: true)
//        }
//
//        if let trainerImage = trainerImage {
//            vm.trainerImage = trainerImage
//        } else {
////            vm.setImageLoading(to: true)
//        }
//
//        return vm
    }
    
    func createHeaderCellViewModel() -> ScheduleHeaderCellProtocol {
        return ScheduleHeaderCell()
    }
}
