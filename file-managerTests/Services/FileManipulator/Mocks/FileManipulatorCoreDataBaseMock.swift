//
//  FileManipulatorCoreDataBaseMock.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import CoreData

@testable import file_manager

class FileManipulatorCoreDataBaseMock: CoreDataBaseContext {
    
    var context = FileManipulatorManageObjectContextFake.empty
    var files = [File]()
    var fetchError: CoreDataBaseError?
    
    var receivedFetchRequest: NSFetchRequest<File>?
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>) -> Result<[T], CoreDataBaseError> where T : NSFetchRequestResult {
        if let fetchRequest = fetchRequest as? NSFetchRequest<File> {
            receivedFetchRequest = fetchRequest
        }
        if let fetchError = fetchError {
            return .failure(fetchError)
        } else if let files = files as? [T] {
            return .success(files)
        } else {
            return .failure(.unknown)
        }
    }
    
    func fetch<T>(fetchRequest: NSFetchRequest<T>, completionHandler: @escaping (Result<[T], CoreDataBaseError>) -> Void) where T : NSFetchRequestResult {
        
    }
    
    func saveContext(completionHandler: ((CoreDataBaseError?) -> Void)?) {
        
    }
}
