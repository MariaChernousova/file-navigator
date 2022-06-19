//
//  FileManipulator.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import CoreData

class FileManipulator: FileManipulatorContext, RestrictedFileManipulatorContext {
    
    let coreDataBase: CoreDataBaseContext
    
    init(coreDataBase: CoreDataBaseContext) {
        self.coreDataBase = coreDataBase
    }
    
    func fetchFile(id: String) -> Result<FileAdapter, AppError> {
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        let fetchResult = fetchFile(with: predicate)
        switch fetchResult {
        case .success(let file):
            let adapter = FileAdapter(file: file)
            return .success(adapter)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchFile(ID: String?) -> Result<File, AppError> {
        let predicate = NSPredicate(format: "%K == %@", "id", ID ?? NSNull())
        return fetchFile(with: predicate)
    }
    
    func fetchFile(with predicate: NSPredicate) -> Result<File, AppError> {
        let fetchRequest: NSFetchRequest<File> = File.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        let fetchResult = coreDataBase.fetch(fetchRequest: fetchRequest)
        switch fetchResult {
        case .success(let files):
            if let firstFile = files.first {
                return .success(firstFile)
            } else {
                return .failure(.dataNotFound)
            }
        case .failure(let systemError):
            return .failure(AppError(systemError))
        }
    }
}
