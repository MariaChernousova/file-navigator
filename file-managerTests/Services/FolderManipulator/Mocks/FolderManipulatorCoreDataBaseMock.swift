//
//  FolderManipulatorCoreDataBaseMock.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import CoreData

@testable import file_manager

class FolderManipulatorCoreDataBaseMock: CoreDataBaseContext {

    var context = FolderManipulatorManageObjectContextFake.empty
    var folders = [Folder]()
    var fetchError: CoreDataBaseError?
    
    var receivedFetchRequest: NSFetchRequest<Folder>?
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>) -> Result<[T], CoreDataBaseError> where T : NSFetchRequestResult {
        if let fetchRequest = fetchRequest as? NSFetchRequest<Folder> {
            receivedFetchRequest = fetchRequest
        }
        if let fetchError = fetchError {
            return .failure(fetchError)
        } else if let folders = folders as? [T] {
            return .success(folders)
        } else {
            return .failure(.unknown)
        }
    }
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>, completionHandler: @escaping (Result<[T], CoreDataBaseError>) -> Void) where T : NSFetchRequestResult {
        
    }
    
    func saveContext(completionHandler: ((CoreDataBaseError?) -> Void)?) {
        
    }
}
