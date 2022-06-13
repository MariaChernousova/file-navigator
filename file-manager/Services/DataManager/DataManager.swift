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
    
    func saveData(with values: [SpreadSheet.Row], completionHandler: @escaping ((Result<Bool, CoreDataStackError>) -> Void)) {
        for row in values {
            switch row.item {
            case .folder:
                let folder = Folder(context: coreDataBase.context)
                folder.id = row.id
                folder.title = row.title
                coreDataBase.saveContext(completionHandler: completionHandler)
                
            case .file:
                let file = File(context: coreDataBase.context)
                file.id = row.id
                file.title = row.title
                if URL(fileURLWithPath: row.title).lastPathComponent == "" {
                    file.nameExtension = nil
                } else {
                    file.nameExtension = URL(fileURLWithPath: row.title).lastPathComponent
                }
                coreDataBase.saveContext(completionHandler: completionHandler)
            }
        }
    }
}
