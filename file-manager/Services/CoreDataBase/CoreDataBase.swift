//
//  CoreDataBase.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation
import CoreData

enum CoreDataStackError: Error {
    case unknown
    case error(NSError)
}

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
    
    func fetch<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
                                        completionHandler: @escaping (Result<[T], CoreDataStackError>) -> Void) {
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { fetchRequest in
            DispatchQueue.main.async {
                if let finalResult = fetchRequest.finalResult {
                    completionHandler(.success(finalResult))
                } else {
                    completionHandler(.failure(.unknown))
                }
            }
        }
        
        do {
            try context.execute(asynchronousFetchRequest)
        } catch let error as NSError {
            completionHandler(.failure(.error(error)))
        }
    }
    
    func saveContext(completionHandler: ((Result<Bool, CoreDataStackError>) -> Void)?) {
        guard context.hasChanges else { return }
        
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = context
        
        do {
            try privateManagedObjectContext.save()
            context.performAndWait {
                do {
                    try self.context.save()
                    DispatchQueue.main.async {
                        completionHandler?(.success(true))
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        completionHandler?(.failure(.error(error)))
                    }
                }
            }
        } catch let error as NSError {
            completionHandler?(.failure(.error(error)))
        }
    }
}
