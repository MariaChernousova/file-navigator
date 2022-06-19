//
//  FolderManipulatorContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

protocol FolderManipulatorContext {
    func fetchFolder(id: String) -> Result<FolderAdapter, AppError>
}

/// Manipulator context that can only be used internally and can be added to service locator.
protocol RestrictedFolderManipulatorContext {
    func fetchFolder(ID: String?) -> Result<Folder, AppError>
}
