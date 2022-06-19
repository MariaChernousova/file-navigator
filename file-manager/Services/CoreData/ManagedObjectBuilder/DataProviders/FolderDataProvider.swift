//
//  FolderDataProvider.swift
//  file-manager
//
//  Created by Chernousova Maria on 17.06.2022.
//

import Foundation

protocol FolderDataProvider: ItemDataProvider {
    var itemIdentifiers: [String] { get }
}

struct FolderData: FolderDataProvider {
    var id: String
    var title: String
    var parentItem: Folder?
    let itemIdentifiers = [String]()
}
