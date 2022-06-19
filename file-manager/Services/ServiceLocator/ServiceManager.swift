//
//  ServiceManager.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol ServiceManager {
    var managedObjectBuilder: ManagedObjectBuilderContext { get }
    var itemManipulator: ItemManipulatorContext { get }
    var folderManipulator: FolderManipulatorContext { get }
    var fileManipulator: FileManipulatorContext { get }
    var networkManager: NetworkManagerContext { get }
    var dataManager: DataManagerContext { get }
}
