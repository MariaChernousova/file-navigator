//
//  FolderModelMock.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 17.06.2022.
//

import Foundation
@testable import file_manager

class FolderModelMock: FolderModelProvider {
    
    var items: [ItemAdapter] = []
    var spreadSheet = SpreadSheetFake.empty
    
    var error: AppError?
    var coreDataBaseError: AppError?
    
    func fetchItems(using resultController: ItemsResultController, parentFolderId: String) {
        CoreDataMock.shared.removeAll()
        let context = CoreDataMock.shared.context
        
        let parentFolder = Folder(context: context)
        parentFolder.parentItem = nil
        parentFolder.id = parentFolderId
        parentFolder.title = UUID().uuidString
        parentFolder.items = []
        
        for (index, item) in items.enumerated() {
            if index % 2 == 0 {
                let file = File(context: context)
                file.parentItem = parentFolder
                file.id = item.id
                file.title = item.title
                file.nameExtension = ""
                parentFolder.addToItems(file)
            } else {
                let folder = Folder(context: context)
                folder.parentItem = parentFolder
                folder.id = item.id
                folder.title = item.title
                folder.items = []
                parentFolder.addToItems(folder)
            }
        }
        
        CoreDataMock.shared.saveContext()
        
        resultController.performFetch(with: context)
    }
    
    func loadData(completionHandler: @escaping (Result<SpreadSheet, AppError>) -> Void) {
        if let error = error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(spreadSheet))
        }
    }
    
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, AppError>) -> Void)) {
        if let coreDataBaseError = coreDataBaseError {
            completionHandler(.failure(coreDataBaseError))
        } else {
            completionHandler(.success(FolderAdapterFake.parentFolder.id))
        }
    }
}
