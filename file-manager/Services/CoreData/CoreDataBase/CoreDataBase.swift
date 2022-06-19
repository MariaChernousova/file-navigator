//
//  CoreDataBase.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import CoreData

class CoreDataBase: RestrictedCoreDataBaseContext, CoreDataBaseContext {
    
    var mainContext: NSManagedObjectContext {
        storeContainer.viewContext
    }
    
    private let modelName: String
    private let privateContextQueue = DispatchQueue(label: "com.maryc.native.file-manager.context", attributes: .concurrent)
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                assertionFailure("Persistens Stores loading has failed: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func fetch<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
                                        completionHandler: @escaping (Result<[T], CoreDataBaseError>) -> Void) {
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { fetchRequest in
            if let finalResult = fetchRequest.finalResult {
                completionHandler(.success(finalResult))
            } else {
                completionHandler(.failure(.unknown))
            }
        }
        
        do {
            try mainContext.execute(asynchronousFetchRequest)
        } catch let error as NSError {
            completionHandler(.failure(.systemError(error)))
        }
    }
    
    func fetch<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>) -> Result<[T], CoreDataBaseError> {
        do {
            let results = try mainContext.fetch(fetchRequest)
            return .success(results)
        } catch let error as NSError {
            return  .failure(.systemError(error))
        }
    }
    
    func saveContext(completionHandler: ((CoreDataBaseError?) -> Void)?) {
        privateContextQueue.async { [weak mainContext] in
            guard let mainContext = mainContext else { return }
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = mainContext
            
            privateContext.perform { [weak privateContext] in
                do {
                    try privateContext?.save()
                    completionHandler?(nil)
                } catch let error as NSError {
                    completionHandler?(.systemError(error))
                }
            }
        }
    }
}
