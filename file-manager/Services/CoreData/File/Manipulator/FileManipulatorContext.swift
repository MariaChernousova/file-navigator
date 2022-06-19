//
//  FileManipulatorContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

protocol FileManipulatorContext {
    func fetchFile(id: String) -> Result<FileAdapter, AppError>
}

/// Manipulator context that can only be used internally and can be added to service locator.
protocol RestrictedFileManipulatorContext {
    func fetchFile(ID: String?) -> Result<File, AppError>
}
