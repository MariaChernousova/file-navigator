//
//  FileDataProvider.swift
//  file-manager
//
//  Created by Chernousova Maria on 17.06.2022.
//

import Foundation

protocol FileDataProvider: ItemDataProvider {
    var nameExtension: String? { get }
}

struct FileData: FileDataProvider {
    var id: String
    var title: String
    var parentItem: Folder?
    var nameExtension: String?
}
