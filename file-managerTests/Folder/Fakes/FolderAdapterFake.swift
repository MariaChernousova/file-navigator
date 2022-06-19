//
//  FolderAdapterFake.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 17.06.2022.
//

import Foundation
@testable import file_manager

class FolderAdapterFake {
    static let parentFolder = FolderAdapter(itemIdentifiers: items.map({ $0.id }), id: UUID().uuidString, title: "Parent Folder", parentItemIdentifiers: nil)
    static let folder1 = FolderAdapter(itemIdentifiers: [], id: UUID().uuidString, title: "Folder1", parentItemIdentifiers: nil)
    static let folder2 = FolderAdapter(itemIdentifiers: [], id: UUID().uuidString, title: "Folder2", parentItemIdentifiers: nil)
    static let file1 = FileAdapter(nameExtension: "", id: UUID().uuidString, title: "File1", parentItemIdentifiers: nil)
    static let file2 = FileAdapter(nameExtension: "", id: UUID().uuidString, title: "File2", parentItemIdentifiers: nil)
    
    static let items: [ItemAdapter] = [folder1, folder2, file1, file2]
}
