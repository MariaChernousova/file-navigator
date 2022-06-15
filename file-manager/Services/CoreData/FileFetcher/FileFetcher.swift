//
//  FileFatcher.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import CoreData

class FileFetcher: FileFetcherContext {
    
    let coreDataBase: CoreDataBaseContext
    
    init(coreDataBase: CoreDataBaseContext) {
        self.coreDataBase = coreDataBase
    }
    
    func fetchFile(fileId: String) -> File {
        let fetchRequest: NSFetchRequest<File> = File.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", fileId)
        let file: File = {
            let result = coreDataBase.fetchSingle(fetchRequest: fetchRequest)
            switch result {
            case .success(let file):
                return file
            case .failure:
                return File(context: coreDataBase.context)
            }
        }()
        return file
    }
}
