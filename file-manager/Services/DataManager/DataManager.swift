//
//  DataManager.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import Foundation

class DataManager: DataManagerContext {
    
    let coreDataBase: CoreDataBaseContext
    
    init(coreDataBase: CoreDataBaseContext) {
        self.coreDataBase = coreDataBase
    }
    
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, CoreDataStackError>) -> Void)) {
        let homeFolderId = UUID().uuidString
        let homeFolder = Folder(context: coreDataBase.context)
        homeFolder.id = homeFolderId
        homeFolder.parentItem = nil
        homeFolder.title = "/"
        homeFolder.items = []
        
        var parentIdItems: [String: [SpreadSheet.Row]] = [:]
        
        for row in rows {
            guard let parentId = row.parentId else { continue }
            if var rows = parentIdItems[parentId] {
                rows.append(row)
                parentIdItems[parentId] = rows
            } else {
                parentIdItems[parentId] = [row]
            }
        }
        
        for row in rows where row.parentId == nil {
            let item = parse(row: row, parentFolder: homeFolder, dataItems: parentIdItems)
            homeFolder.addToItems(item)
        }
        
        coreDataBase.saveContext { result in
            switch result {
            case .success(let success):
                if success {
                    completionHandler(.success(homeFolderId))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    func parse(row: SpreadSheet.Row, parentFolder: Folder, dataItems: [String: [SpreadSheet.Row]]) -> Item {
        let item: Item
        switch row.item {
        case .file:
            let file = File(context: coreDataBase.context)
            file.id = row.id
            file.title = row.title
            file.parentItem = parentFolder
            if URL(fileURLWithPath: row.title).lastPathComponent == "" {
                file.nameExtension = nil
            } else {
                file.nameExtension = URL(fileURLWithPath: row.title).lastPathComponent
            }
            
            item = file
        case .folder:
            let folder = Folder(context: coreDataBase.context)
            folder.id = row.id
            folder.title = row.title
            folder.parentItem = parentFolder
            
            if let items = dataItems[row.id] {
                for item in items {
                    let newItem = parse(row: item, parentFolder: folder, dataItems: dataItems)
                    folder.addToItems(newItem)
                    
                }
            }
            
            item = folder
        }
        
        return item
    }
}

