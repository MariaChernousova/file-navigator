//
//  ItemsResultController.swift
//  file-manager
//
//  Created by Chernousova Maria on 15.06.2022.
//

import UIKit
import CoreData

typealias ItemsResultDataSource = UICollectionViewDiffableDataSource<Section, ItemAdapter>
typealias ItemsResultSnapshot = NSDiffableDataSourceSnapshot<Section, ItemAdapter>

typealias ItemsResultUpdateHandler = (ItemsResultSnapshot) -> Void

enum Section: Int {
    case main
}

class ItemsResultController: NSObject, ResultControllerContext {
    
    typealias UpdateHandler = (Result<ItemsResultSnapshot, NSError>) -> Void
    
    var fetchRequest = Item.fetchRequest()
    var updateHandler: UpdateHandler
    
    private var fetchResultController: NSFetchedResultsController<Item>?
    
    init(updateHandler: @escaping UpdateHandler) {
        self.updateHandler = updateHandler
    }
    
    convenience override init() {
        self.init { _ in }
    }
    
    func performFetch(with context: NSManagedObjectContext) {
        if fetchResultController == nil {
            configureResultController(
                with: fetchRequest,
                context: context
            )
        }
        
        do {
            try fetchResultController?.performFetch()
        } catch let error as NSError {
            updateHandler(.failure(error))
        }
    }
    
    private func configureResultController(
        with fetchRequest: NSFetchRequest<Item>,
        context: NSManagedObjectContext
    ) {
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        fetchResultController = controller
    }
}

extension ItemsResultController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let controllerSnapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        var newSnapshot = ItemsResultSnapshot()
        
        let items = convert(items: controllerSnapshot.itemIdentifiers, at: Section.main.rawValue)
        newSnapshot.appendSections([.main])
        newSnapshot.appendItems(items)
        
        updateHandler(.success(newSnapshot))
    }
    
    private func convert(items: [NSManagedObjectID], at sectionIndex: Int) -> [ItemAdapter] {
        guard let fetchResultController = fetchResultController else {
            return []
        }
        var itemAdapters: [ItemAdapter] = []
        for (index, _) in items.enumerated() {
            let indexPath = IndexPath(row: index, section: sectionIndex)
            let managedItem = fetchResultController.object(at: indexPath)
            
            if let file = managedItem as? File {
                let fileAdapter = FileAdapter(file: file)
                itemAdapters.append(fileAdapter)
            } else if let folder = managedItem as? Folder {
                let folder = FolderAdapter(folder: folder)
                itemAdapters.append(folder)
            }
        }
        return itemAdapters
    }
}
