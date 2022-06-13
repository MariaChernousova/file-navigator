//
//  FolderViewModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FolderViewModelProvider {
    func didLoad()
}

class FolderViewModel: FolderViewModelProvider {
    typealias PathHandler = (FolderCoordinator.Path) -> Void
    
    var folderViewModelProvider: FolderViewModelProvider { self }
    var updateAction: (([Item]) -> Void)?
    
    private let model: FolderModelProvider
    private let pathHandler: PathHandler
    
    init(model: FolderModelProvider, pathHandler: @escaping PathHandler) {
        self.model = model
        self.pathHandler = pathHandler
    }
    
    // MARK: - Public methods.
    
    func didLoad() {
        model.loadData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let spreadsheet):
                self.saveData(rows: spreadsheet.values) { result in
                    switch result {
                    case .success(let homeFolderId):
                        self.fetchRows(with: homeFolderId) { result in
                            switch result {
                            case .success(let snapshot):
                                print(snapshot)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Private methods.
    
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, CoreDataStackError>) -> Void)) {
        model.saveData(rows: rows, completionHandler: completionHandler)
    }
    
    private func fetchRows(with parentFolderId: String, updateHandler: @escaping ItemsFetcherUpdateHandler) {
        model.fetchItems(with: parentFolderId, updateHandler: updateHandler)
    }
}
