//
//  FileModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FileModelProvider {
    func fetchFile(with id: String) -> Result<FileAdapter, AppError>
}

class FileModel: FileModelProvider {
    
    private let fileFetcher: FileManipulatorContext
    
    init(serviceManager: ServiceManager) {
        self.fileFetcher = serviceManager.fileManipulator
    }
    
    func fetchFile(with id: String) -> Result<FileAdapter, AppError> {
        fileFetcher.fetchFile(id: id)
    }
}
