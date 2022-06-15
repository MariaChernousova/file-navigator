//
//  File+CoreDataProperties.swift
//  file-manager
//
//  Created by Eric Golovin on 6/16/22.
//
//

import Foundation
import CoreData


extension File {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<File> {
        return NSFetchRequest<File>(entityName: "File")
    }

    @NSManaged public var nameExtension: String?

}
