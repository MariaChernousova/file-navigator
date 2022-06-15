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
        if let folderItems = folder.items?.array as? [Item] {
            itemIdentifiers = folderItems.compactMap { $0.id }
        } else {
            itemIdentifiers = []
        }
        super.init(item: folder)
    }
}
