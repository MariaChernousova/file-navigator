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
        self.id = item.id ?? ""
        self.title = item.title ?? ""
        self.parentItemIdentifiers = item.parentItem?.id
    }
    
    init(id: String, title: String, parentItemIdentifiers: String?) {
        self.id = id
        self.title = title
        self.parentItemIdentifiers = parentItemIdentifiers
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
