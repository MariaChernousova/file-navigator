//
//  FileModelMock.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 18.06.2022.
//

import Foundation
@testable import file_manager

class FileModelMock: FileModelProvider {
    
    var fileAdapter: FileAdapter?
    
    func fetchFile(with id: String) -> Result<FileAdapter, AppError> {
        guard let file = fileAdapter else {
            return .failure(.dataNotFound)
        }
        return .success(file)
    }
}
