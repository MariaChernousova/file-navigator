//
//  ManagedObjectBuilder.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import CoreData

class ManagedObjectBuilder: ManagedObjectBuilderContext {
    
    func buildItem(_ data: ItemDataProvider, context: NSManagedObjectContext) -> Item {
        let item = Item(context: context)
        return configure(item, with: data)
    }
     
    func buildFolder(_ data: FolderDataProvider, context: NSManagedObjectContext) -> Folder {
        let folder = Folder(context: context)
        return configure(folder, with: data)
    }
    
    func buildFile(_ data: FileDataProvider, context: NSManagedObjectContext) -> File {
        let file = File(context: context)
        return configure(file, with: data)
    }
    
    private func configure<T: Item>(_ object: T, with data: ItemDataProvider) -> T {
        object.id = data.id
        object.parentItem = data.parentItem
        object.title = data.title
        return object
    }
}
