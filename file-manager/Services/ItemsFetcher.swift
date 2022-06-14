//
//  ItemsFetcher.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import UIKit
import CoreData

class ItemsFetcher: NSObject, ItemsFetcherContext {
    
    var fetchResultController: NSFetchedResultsController<Item>?
    
    private let coreDataBaseContext: CoreDataBaseContext
    
    private var updateHandler: ItemsFetcherUpdateHandler?
    
    init(coreDataBaseContext: CoreDataBaseContext) {
        self.coreDataBaseContext = coreDataBaseContext
    }
    
    func fetchItems(with parentFolderId: String, updateHandler: @escaping ItemsFetcherUpdateHandler) {
        self.updateHandler = updateHandler
        
        let fetchRequest = configureFetchRequest(with: parentFolderId)
        configureFetchResultController(with: fetchRequest)
        
        do {
            try fetchResultController?.performFetch()
        } catch let error as NSError {
            updateHandler(.failure(error))
        }
    }
    
    private func configureFetchRequest(with parentFolderId: String) -> NSFetchRequest<Item> {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "parentItem.id", parentFolderId)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.title, ascending: true)
        ]
        return fetchRequest
    }
    
    private func configureFetchResultController(with fetchRequest: NSFetchRequest<Item>) {
        fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataBaseContext.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchResultController?.delegate = self
    }
}

extension ItemsFetcher: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        updateHandler?(.success(snapshot as ItemsFetcherSnapshot))
    }
}
