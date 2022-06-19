//
//  ItemManipulatorItemFake.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import Foundation
@testable import file_manager

struct ItemManipulatorItemFake {
    
    static let item: Item = {
        let item = Item(context: ItemManipulatorManageObjectContextFake.empty)
        item.id = UUID().uuidString
        item.title = ""
        return item
    }()
}
