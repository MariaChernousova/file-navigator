//
//  ItemAdapter.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

class ItemAdapter {
    
    let id: String
    let title: String
    let parentItemIdentifiers: String?
    
    init(item: Item) {
        if let id = item.id, let title = item.title, let parentItem = item.parentItem {
            self.id = id
            self.title = title
            self.parentItemIdentifiers = parentItem.id
        } else {
            self.id = ""
            self.title = ""
            self.parentItemIdentifiers = nil
        }
    }
}

extension ItemAdapter: Hashable {
    static func == (lhs: ItemAdapter, rhs: ItemAdapter) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
