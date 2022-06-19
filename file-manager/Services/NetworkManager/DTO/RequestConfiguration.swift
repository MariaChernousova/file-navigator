//
//  RequestConfiguration.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

struct RequestConfiguration: RequestConfigurationContext {
    let sheetID = "1zh-hfE9O14gaHi33bpWlsyZ89j-WqyIFezr2fqgGtW8"
    let range = "Sheet1!A:E"
    let key = "AIzaSyC_Sm41W-Dj8_WFJAJyDDl8mVumljbC2Rg"
    let httpHeader = "X-Ios-Bundle-Identifier"
    
    func buildURL() -> URL? {
        URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)?key=\(key)")
    }
}
