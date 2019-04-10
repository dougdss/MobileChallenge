//
//  CoreDataManager.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 07/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    var modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
        initializeStack()
    }
    
    private(set) var  managedObjectContext: NSManagedObjectContext?
    private var managedObjectModel: NSManagedObjectModel?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    private func initializeStack() {
        
        //model
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Cannot find data model")
        }
        
        if let managedModel = NSManagedObjectModel(contentsOf: modelURL) {
            managedObjectModel = managedModel
            
            //persisntent coordinator
            initializePersistentStore(withModel: managedModel)
            
            // context
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = self.persistentStoreCoordinator
            
        } else {
            fatalError("Cannot load data model")
        }

    }
    
    private func initializePersistentStore(withModel model: NSManagedObjectModel) {
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        //config coordinator
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistenStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                               configurationName: nil,
                                                               at: persistenStoreURL,
                                                               options: nil)
        } catch {
            fatalError("Cannot load persisten store")
        }
    }
    
}
