//
//  FolderViewModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation
import CoreData

protocol FolderViewModelProvider {
    func didLoad()
}

class FolderViewModel: NSObject {
    typealias PathHandler = (FolderCoordinator.Path) -> Void
    
    var folderViewModelProvider: FolderViewModelProvider { self }
    var updateAction: (([Item]) -> Void)?
    
    private let model: FolderModelProvider
    private let pathHandler: PathHandler
    
    init(model: FolderModelProvider, pathHandler: @escaping PathHandler) {
        self.model = model
        self.pathHandler = pathHandler
    }
}

extension FolderViewModel: FolderViewModelProvider {
    func didLoad() {

    }
}

extension FolderViewModel: NSFetchedResultsControllerDelegate {
    
}
