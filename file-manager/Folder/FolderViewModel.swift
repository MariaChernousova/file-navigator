//
//  FolderViewModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FolderViewModelProvider {
    var showErrorAlert: (_ title: String, _ message: String) -> Void { get set}
    var updateLoading: (Bool) -> Void { get set }
    func setUpdateHandler(_ updateHandler: @escaping ItemsResultUpdateHandler)
    
    func didLoad()
    func select(item: ItemAdapter)
}

class FolderViewModel: FolderViewModelProvider {

    typealias PathHandler = (FolderCoordinator.Path) -> Void
    
    private let folderId: String?
    private let model: FolderModelProvider
    private let pathHandler: PathHandler
    
    private let itemsResultController = ItemsResultController()
    
    var showErrorAlert: ( _ title: String, _ message: String) -> Void = { _, _ in }
    var updateLoading: (Bool) -> Void = { _ in }
    
    init(folderId: String?,
         model: FolderModelProvider,
         pathHandler: @escaping PathHandler) {
        self.folderId = folderId
        self.model = model
        self.pathHandler = pathHandler
    }
    
    // MARK: - Public methods.
    
    func setUpdateHandler(_ updateHandler: @escaping ItemsResultUpdateHandler) {
        itemsResultController.updateHandler = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let snapshot):
                self.updateLoading(false)
                updateHandler(snapshot)
            case .failure(let error):
                self.handlerError(error)
            }
        }
    }
    
    func didLoad() {
        updateLoading(true)
        if let folderId = folderId {
            fetchRows(with: folderId)
        } else {
            model.loadData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let spreadsheet):
                    self.saveData(rows: spreadsheet.values) { result in
                        switch result {
                        case .success(let homeFolderId):
                            self.fetchRows(with: homeFolderId)
                        case .failure(let error):
                            self.handlerError(error)
                        }
                    }
                case .failure(let error):
                    self.handlerError(error)
                }
            }
        }
    }
    
    func select(item: ItemAdapter) {
        if let folder = item as? FolderAdapter {
            pathHandler(.folder(id: folder.id))
        } else if let file = item as? FileAdapter {
            pathHandler(.file(id: file.id))
        }
    }
    
    // MARK: - Private methods.
    
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, AppError>) -> Void)) {
        model.saveData(rows: rows, completionHandler: completionHandler)
    }
    
    private func fetchRows(with parentFolderId: String) {
        model.fetchItems(using: self.itemsResultController, parentFolderId: parentFolderId)
    }
    
    private func handlerError(_ error: AppError) {
        showErrorAlert(error.title, error.description)
    }
}
