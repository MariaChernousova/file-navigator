//
//  ItemManipulator.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import CoreData

class ItemManipulator: NSObject, ItemManipulatorContext {
    
    typealias CoreDataBase = RestrictedCoreDataBaseContext & CoreDataBaseContext
    
    private let coreDataBase: CoreDataBase
    
    init(coreDataBase: CoreDataBase) {
        self.coreDataBase = coreDataBase
    }
    
    func fetchItem(with id: String) -> Result<ItemAdapter, AppError> {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", id)
        
        let fetchResult = coreDataBase.fetch(fetchRequest: fetchRequest)
        switch fetchResult {
        case .success(let items):
            if let firstItem = items.first {
                let adapter = ItemAdapter(item: firstItem)
                return .success(adapter)
            } else {
                return .failure(.dataNotFound)
            }
        case .failure(let systemError):
            let error = AppError(systemError)
            return .failure(error)
        }
    }
    
    func fetchItems<ResultController: ResultControllerContext>(
        using resultController: ResultController,
        parentFolderId: String
    ) where ResultController.ResultType == Item {
        DispatchQueue.main.async {
            let fetchRequest = resultController.fetchRequest
            fetchRequest.predicate = NSPredicate(format: "%K == %@", "parentItem.id", parentFolderId)
            resultController.performFetch(with: self.coreDataBase.mainContext)
        }
    }
}
