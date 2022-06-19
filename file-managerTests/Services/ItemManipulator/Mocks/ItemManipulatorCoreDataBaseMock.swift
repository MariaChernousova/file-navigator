//
//  ItemManipulatorCoreDataBaseMock.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import CoreData

@testable import file_manager

class ItemManipulatorCoreDataBaseMock: ItemManipulator.CoreDataBase {

    var mainContext: NSManagedObjectContext = ItemManipulatorManageObjectContextFake.empty
    
    var items = [Item]()
    var fetchError: CoreDataBaseError?
    
    var receivedFetchRequest: NSFetchRequest<Item>?
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>) -> Result<[T], CoreDataBaseError> where T : NSFetchRequestResult {
        if let fetchRequest = fetchRequest as? NSFetchRequest<Item> {
            receivedFetchRequest = fetchRequest
        }
        if let fetchError = fetchError {
            return .failure(fetchError)
        } else if let items = items as? [T] {
            return .success(items)
        } else {
            return .failure(.unknown)
        }
    }
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>, completionHandler: @escaping (Result<[T], CoreDataBaseError>) -> Void) where T : NSFetchRequestResult {
        
    }
    
    func saveContext(completionHandler: ((CoreDataBaseError?) -> Void)?) {
        
    }
}
