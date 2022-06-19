//
//  FolderModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FolderModelProvider {
    func fetchItems(
        using resultController: ItemsResultController,
        parentFolderId: String
    )
    func loadData(completionHandler: @escaping (Result<SpreadSheet, AppError>) -> Void)
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, AppError>) -> Void))
}

class FolderModel: FolderModelProvider {

    private let itemsFetcher: ItemManipulatorContext
    private let networkManager: NetworkManagerContext
    private let dataManager: DataManagerContext
      
    init(serviceManager: ServiceManager) {
        self.itemsFetcher = serviceManager.itemManipulator
        self.networkManager = serviceManager.networkManager
        self.dataManager = serviceManager.dataManager
    }
    
    func fetchItems(
        using resultController: ItemsResultController,
        parentFolderId: String
    ) {
        itemsFetcher.fetchItems(
            using: resultController,
            parentFolderId: parentFolderId
        )
    }
    
    func loadData(completionHandler: @escaping (Result<SpreadSheet, AppError>) -> Void) {
        networkManager.loadData(completionHandler: completionHandler)
    }
    
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, AppError>) -> Void)) {
        dataManager.saveData(rows: rows, completionHandler: completionHandler)
    }
}
