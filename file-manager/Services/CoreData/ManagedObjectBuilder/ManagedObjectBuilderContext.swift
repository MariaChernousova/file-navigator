//
//  ManagedObjectBuilderContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import CoreData

protocol ManagedObjectBuilderContext {
    func buildItem(_ data: ItemDataProvider, context: NSManagedObjectContext) -> Item
    func buildFolder(_ data: FolderDataProvider, context: NSManagedObjectContext) -> Folder
    func buildFile(_ data: FileDataProvider, context: NSManagedObjectContext) -> File
}
