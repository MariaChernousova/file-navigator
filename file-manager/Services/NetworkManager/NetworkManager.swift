//
//  NetworkManager.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
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

class NetworkManager: NetworkManagerContext {
    
    let sheetID = "1zh-hfE9O14gaHi33bpWlsyZ89j-WqyIFezr2fqgGtW8"
    let range = "Sheet1!A:E"
    
    func loadData(completionHandler: @escaping (Result<SpreadSheet, Error>) -> Void) {
        guard let url = buildURL(),
              let bundleIdentifier =  Bundle.main.bundleIdentifier else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue(bundleIdentifier, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                
            } else if let response = response {
                
            }
            
            do {
                let spreadsheet = try JSONDecoder().decode(SpreadSheet.self, from: data!)
                
                completionHandler(.success(spreadsheet))
            } catch let error {
                
                completionHandler(.failure(error))
            }
        }.resume()
    }
    
    private func buildURL() -> URL? {
        URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)?key=AIzaSyC_Sm41W-Dj8_WFJAJyDDl8mVumljbC2Rg")
    }
}

