//
//  TrainerEntity+CoreDataProperties.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 07/03/2021.
//
//

import Foundation
import CoreData


extension TrainerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainerEntity> {
        return NSFetchRequest<TrainerEntity>(entityName: "TrainerEntity")
    }

    @NSManaged public var forename: String?
    @NSManaged public var surname: String?

}

extension TrainerEntity : Identifiable {

}
