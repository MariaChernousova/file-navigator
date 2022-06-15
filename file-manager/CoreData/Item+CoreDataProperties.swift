//
//  Item+CoreDataProperties.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var parentItem: Folder?

}

extension Item : Identifiable {

}
