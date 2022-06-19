//
//  FileAdapter.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

class FileAdapter: ItemAdapter {
    
    let nameExtension: String?
    
    init(file: File) {
        nameExtension = file.nameExtension
        super.init(item: file)
    }
    
    init(nameExtension: String?, id: String, title: String, parentItemIdentifiers: String?) {
        self.nameExtension = nameExtension
        super.init(id: id, title: title, parentItemIdentifiers: parentItemIdentifiers)
    }
}
