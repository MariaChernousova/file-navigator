//
//  SpreadSheet.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

struct SpreadSheet: Codable {
    
    enum Item: String, Codable {
        case folder = "d"
        case file = "f"
    }
    
    struct Row: Codable {
        let id: String
        let parentId: String?
        let item: Item
        let title: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let values = try container.decode([String].self)
            
            guard values.count == 4,
                  let item = Item(rawValue: values[2]) else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "😳"))
            }
            
            self.id = values[0]
            self.parentId = values[1].isEmpty ? nil : values[1]
            self.item = item
            self.title = values[3]
        }
    }
    
    let range: String
    let majorDimension: String
    let values: [Row]
}
