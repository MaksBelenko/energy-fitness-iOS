//
//  CoreDataStack.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 07/03/2021.
//

import Foundation
import CoreData

class CoreDataStack {
    
    public static let modelName = "EnergyDbModel"
    
    // MARK: - Core Data stack
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
}
