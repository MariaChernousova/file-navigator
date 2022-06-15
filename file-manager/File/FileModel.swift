//
//  FileModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FileModelProvider {
    func fetchFile(fileId: String) -> File
}

class FileModel: FileModelProvider {
    private let fileFetcher: FileFetcherContext
    
    init(serviceManager: ServiceManager) {
        self.fileFetcher = serviceManager.fileFetcher
    }
    
    func fetchFile(fileId: String) -> File {
        fileFetcher.fetchFile(fileId: fileId)
    }
}
