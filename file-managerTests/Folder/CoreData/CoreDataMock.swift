//
//  CoreDataMock.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 17.06.2022.
//

import CoreData

@testable import file_manager

class CoreDataMock {
    
    static let shared = CoreDataMock()
    
    var context: NSManagedObjectContext {
        storeContainer.viewContext
    }

    private init() { }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "file_manager")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                assertionFailure("Persistens Stores loading has failed: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func fetch<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>) -> Result<[T], CoreDataBaseError> {
        do {
            let results = try context.fetch(fetchRequest)
            return .success(results)
        } catch let error as NSError {
            return .failure(.systemError(error))
        }
    }
    
    @discardableResult
    func saveContext() -> CoreDataBaseError? {
        guard context.hasChanges else { return .unknown }
        
        do {
            try context.save()
        } catch let error as NSError {
            return .systemError(error)
        }
        
        return nil
    }
    
    @discardableResult
    func removeAll() -> CoreDataBaseError? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            return .systemError(error)
        }
        
        return nil
    }
}
