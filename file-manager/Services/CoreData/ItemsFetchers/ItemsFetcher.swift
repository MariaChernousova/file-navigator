//
//  ItemsFetcher.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import CoreData

class ItemsFetcher: NSObject, ItemsFetcherContext {
    
    private let coreDataBaseContext: CoreDataBaseContext
    
    init(coreDataBaseContext: CoreDataBaseContext) {
        self.coreDataBaseContext = coreDataBaseContext
    }
    
    func fetchItems<ResultController: ResultControllerContext>(
        using resultController: ResultController,
        parentFolderId: String
    ) where ResultController.ResultType == Item {
        configure(
            fetchRequest: resultController.fetchRequest,
            parentFolderId: parentFolderId
        )
        resultController.performFetch(with: coreDataBaseContext.context)
    }
    
    private func configure(
        fetchRequest: NSFetchRequest<Item>,
        parentFolderId: String
    ) {
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "parentItem.id", parentFolderId)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.title, ascending: true)
        ]
    }
}
