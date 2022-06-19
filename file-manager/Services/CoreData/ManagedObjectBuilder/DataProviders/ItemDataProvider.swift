//
//  ItemDataProvider.swift
//  file-manager
//
//  Created by Chernousova Maria on 17.06.2022.
//

import Foundation

protocol ItemDataProvider {
    var id: String { get }
    var title: String { get }
    var parentItem: Folder? { get }
}

struct ItemData: ItemDataProvider {
    var id: String
    var title: String
    var parentItem: Folder?
}
