//
//  FileViewModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FileViewModelProvider {
    var file: FileAdapter? { get }
    var showErrorAlert: (_ title: String, _ message: String) -> Void { get set}
    var updateLoading: (Bool) -> Void { get set }
    func didLoad()
}

class FileViewModel: FileViewModelProvider {
    
    private let fileId: String
    private let model: FileModelProvider
        
    var file: FileAdapter?
    var showErrorAlert: ( _ title: String, _ message: String) -> Void = { _, _ in }
    var updateLoading: (Bool) -> Void = { _ in }
    
    init(fileId: String, model: FileModelProvider) {
        self.fileId = fileId
        self.model = model
    }
    
    func didLoad() {
        self.updateLoading(true)
        let result = model.fetchFile(with: fileId)
        switch result {
        case .success(let file):
            self.file = file
            self.updateLoading(false)
        case .failure(let error):
            self.handlerError(error: error)
        }
    }
    
    private func handlerError(error: AppError) {
        showErrorAlert("Error", error.localizedDescription)
    }
}
