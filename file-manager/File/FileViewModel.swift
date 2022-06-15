//
//  FileViewModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol FileViewModelProvider {
    var file: File { get }
}

class FileViewModel: FileViewModelProvider {
    var file: File
    let model: FileModelProvider
    
    init(file: File, model: FileModelProvider) {
        self.file = file
        self.model = model
    }
}
