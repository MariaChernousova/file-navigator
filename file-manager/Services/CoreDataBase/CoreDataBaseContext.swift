//
//  CoreDataBaseContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation
import CoreData

protocol CoreDataBaseContext {
    var context: NSManagedObjectContext { get }
    
    func saveContext(completionHandler: ((Result<Bool, CoreDataStackError>) -> Void)?)
    func fetchSingle<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>) -> Result<T, CoreDataStackError>
}
