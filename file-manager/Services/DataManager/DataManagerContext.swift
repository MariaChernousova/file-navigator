//
//  DataManagerContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import Foundation

protocol DataManagerContext {
    func saveData(rows: [SpreadSheet.Row], completionHandler: @escaping ((Result<String, AppError>) -> Void))
}
