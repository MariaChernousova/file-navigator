//
//  SpreadSheetFake.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 18.06.2022.
//

import Foundation
@testable import file_manager

struct SpreadSheetFake {
    static let empty = SpreadSheet(range: "", majorDimension: "", values: [])
}
