//
//  CoreDataBaseContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import CoreData

enum CoreDataBaseError: Error {
    case unknown
    case systemError(NSError)
}

protocol RestrictedCoreDataBaseContext {
    var mainContext: NSManagedObjectContext { get }
}

protocol CoreDataBaseContext {    
    func fetch<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
                                        completionHandler: @escaping (Result<[T], CoreDataBaseError>) -> Void)
    func fetch<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>) -> Result<[T], CoreDataBaseError>
    func saveContext(completionHandler: ((CoreDataBaseError?) -> Void)?)
}
