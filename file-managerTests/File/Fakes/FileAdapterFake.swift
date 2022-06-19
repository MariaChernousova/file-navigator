//
//  FileAdapterFake.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 18.06.2022.
//

import Foundation
@testable import file_manager

class FileAdapterFake {
    static let file = FileAdapter(nameExtension: "", id: UUID().uuidString, title: "File", parentItemIdentifiers: nil)
}
