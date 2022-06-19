//
//  ResultControllerContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import CoreData

protocol ResultControllerContext {
    associatedtype ResultType: NSFetchRequestResult
    
    var fetchRequest: NSFetchRequest<ResultType> { get }
    
    func performFetch(with context: NSManagedObjectContext)
}
