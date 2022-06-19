//
//  FolderAdapter.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

class FolderAdapter: ItemAdapter {
    
    let itemIdentifiers: [String]
    
    init(folder: Folder) {
        itemIdentifiers = (folder.items?.array as? [Item])?.compactMap { $0.id } ?? []
        super.init(item: folder)
    }
    
    init(itemIdentifiers: [String], id: String, title: String, parentItemIdentifiers: String?) {
        self.itemIdentifiers = itemIdentifiers
        super.init(id: id, title: title, parentItemIdentifiers: parentItemIdentifiers)
    }
}
