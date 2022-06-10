//
//  CoreDataBase.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation
import CoreData

class CoreDataBase: CoreDataBaseContext {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var context = storeContainer.viewContext
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
