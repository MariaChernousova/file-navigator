//
//  FolderManipulator.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import CoreData

class FolderManipulator: FolderManipulatorContext, RestrictedFolderManipulatorContext {
    
    let coreDataBase: CoreDataBaseContext
    
    init(coreDataBase: CoreDataBaseContext) {
        self.coreDataBase = coreDataBase
    }
    
    func fetchFolder(id: String) -> Result<FolderAdapter, AppError> {
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        let fetchResult = fetchFolder(with: predicate)
        switch fetchResult {
        case .success(let folder):
            let adapter = FolderAdapter(folder: folder)
            return .success(adapter)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchFolder(ID: String?) -> Result<Folder, AppError> {
        let predicate = NSPredicate(format: "%K == %@", "id", ID ?? NSNull())
        return fetchFolder(with: predicate)
    }
    
    private func fetchFolder(with predicate: NSPredicate) -> Result<Folder, AppError> {
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        let fetchResult = coreDataBase.fetch(fetchRequest: fetchRequest)
        switch fetchResult {
        case .success(let folders):
            if let firstFolder = folders.first {
                return .success(firstFolder)
            } else {
                return .failure(.dataNotFound)
            }
        case .failure(let systemError):
            return .failure(AppError(systemError))
        }
    }
}
