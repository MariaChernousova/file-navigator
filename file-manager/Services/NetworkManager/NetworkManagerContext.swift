//
//  NetworkManagerContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol RequestConfigurationContext {
    var sheetID: String { get }
    var range: String { get }
    var httpHeader: String { get }
    var key: String { get }
    
    func buildURL() -> URL?
}

protocol NetworkManagerContext {
    func loadData<T: Codable>(completionHandler: @escaping (Result<T, AppError>) -> Void)
}
