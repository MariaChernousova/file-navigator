//
//  Item+CoreDataProperties.swift
//  file-manager
//
//  Created by Eric Golovin on 6/16/22.
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
