//
//  File+CoreDataProperties.swift
//  file-manager
//
//  Created by Chernousova Maria on 09.06.2022.
//
//

import Foundation
import CoreData


extension File {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<File> {
        return NSFetchRequest<File>(entityName: "File")
    }

    @NSManaged public var nameExtension: String?
    @NSManaged public var title: String?

}
