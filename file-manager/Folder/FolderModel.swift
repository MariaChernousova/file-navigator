//
//  FolderModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FolderModelProvider {
    func loadData(completionHandler: @escaping (Result<SpreadSheet, Error>) -> Void)
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, CoreDataStackError>) -> Void))
    func fetchItems(with parentFolderId: String,
                    updateHandler: @escaping ItemsFetcherUpdateHandler)
}

class FolderModel: FolderModelProvider {

    private let itemsFetcher: ItemsFetcherContext
    private let networkManager: NetworkManagerContext
    private let dataManager: DataManagerContext
      
    init(serviceManager: ServiceManager) {
        self.itemsFetcher = serviceManager.itemsFetcher
        self.networkManager = serviceManager.networkManager
        self.dataManager = serviceManager.dataManager
    }
    
    func loadData(completionHandler: @escaping (Result<SpreadSheet, Error>) -> Void) {
        networkManager.loadData(completionHandler: completionHandler)
    }
    
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, CoreDataStackError>) -> Void)) {
        dataManager.saveData(rows: rows, completionHandler: completionHandler)
    }
    
    func fetchItems(with parentFolderId: String, updateHandler: @escaping ItemsFetcherUpdateHandler) {
        itemsFetcher.fetchItems(with: parentFolderId, updateHandler: updateHandler)
    }
}
