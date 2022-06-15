//
//  FileViewModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FileViewModelProvider {
    var file: File? { get }
    func didLoad()
}

class FileViewModel: FileViewModelProvider {
    
    private let fileId: String
    private let model: FileModelProvider
    
//    private let itemsResultController = ItemsResultController()
    
    var file: File?
    
    init(fileId: String, model: FileModelProvider) {
        self.fileId = fileId
        self.model = model
    }
    
    func didLoad() {
        self.fetchFile(with: fileId)
    }
    
    private func fetchFile(with fileId: String) {
        file = model.fetchFile(fileId: fileId)
    }
}
