//
//  NetworkManagerContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol NetworkManagerContext {
    func loadData(completionHandler: @escaping (Result<SpreadSheet, Error>) -> Void)
}
