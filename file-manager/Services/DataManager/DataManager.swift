//
//  DataManager.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import CoreData

class DataManager: DataManagerContext {
    
    typealias CoreDataBase = CoreDataBaseContext & RestrictedCoreDataBaseContext
    
    let coreDataBase: CoreDataBase
    let managedObjectBuilder: ManagedObjectBuilderContext
    let folderManipulator: RestrictedFolderManipulatorContext
    let fileManipulator: RestrictedFileManipulatorContext
    
    init(coreDataBase: CoreDataBase,
         managedObjectBuilder: ManagedObjectBuilderContext,
         folderManipulator: RestrictedFolderManipulatorContext,
         fileManipulator: RestrictedFileManipulatorContext) {
        self.coreDataBase = coreDataBase
        self.managedObjectBuilder = managedObjectBuilder
        self.folderManipulator = folderManipulator
        self.fileManipulator = fileManipulator
    }
    
    func saveData(rows: [SpreadSheet.Row],
                  completionHandler: @escaping ((Result<String, AppError>) -> Void)) {
        DispatchQueue.main.async {
            self.startParsing(rows: rows, completionHandler: completionHandler)
        }
    }
    
    private func startParsing(rows: [SpreadSheet.Row],
                    completionHandler: @escaping ((Result<String, AppError>) -> Void)) {
            let homeFolder: Folder = {
                let result = self.folderManipulator.fetchFolder(ID: nil)
                switch result {
                case .success(let folder):
                    return folder
                case .failure:
                    let data = FolderData(id: UUID().uuidString, title: "/")
                    return self.managedObjectBuilder.buildFolder(data, context: coreDataBase.mainContext)
                }
            }()
            homeFolder.title = "/"
            homeFolder.parentItem = nil
            
            let homeFolderId = homeFolder.id ?? nil
            
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
                let item = self.parse(row: row, parentFolder: homeFolder, dataItems: parentIdItems, context: coreDataBase.mainContext)
                homeFolder.addToItems(item)
            }
            
            self.coreDataBase.saveContext { result in
                switch result {
                case .none:
                    guard let homeFolderId = homeFolderId else { return }
                        completionHandler(.success(homeFolderId))
                case .some(let error):
                    completionHandler(.failure(AppError(error)))
                }
            }
    }
    
    private func parse(row: SpreadSheet.Row, parentFolder: Folder, dataItems: [String: [SpreadSheet.Row]], context: NSManagedObjectContext) -> Item {
        let item: Item
        switch row.item {
        case .file:
            let file: File = {
                let result = fileManipulator.fetchFile(ID: row.id)
                switch result {
                case .success(let file):
                    return file
                case .failure:
                    let data = FileData(id: row.id, title: row.title, parentItem: parentFolder)
                    return managedObjectBuilder.buildFile(data, context: coreDataBase.mainContext)
                }
            }()
            
            file.title = row.title
            file.parentItem = parentFolder
            if URL(fileURLWithPath: row.title).lastPathComponent == "" {
                file.nameExtension = nil
            } else {
                file.nameExtension = URL(fileURLWithPath: row.title).lastPathComponent
            }
            
            item = file
        case .folder:
            let folder: Folder = {
                let result = folderManipulator.fetchFolder(ID: row.id)
                switch result {
                case .success(let folder):
                    return folder
                case .failure:
                    let data = FolderData(id: row.id, title: row.title, parentItem: parentFolder)
                    return managedObjectBuilder.buildFolder(data, context: coreDataBase.mainContext)
                }
            }()
            
            folder.title = row.title
            folder.parentItem = parentFolder
            
            if let items = dataItems[row.id] {
                for item in items {
                    let newItem = parse(row: item, parentFolder: folder, dataItems: dataItems, context: coreDataBase.mainContext)
                    folder.addToItems(newItem)
                }
            }
            
            item = folder
        }
        
        return item
    }
}
