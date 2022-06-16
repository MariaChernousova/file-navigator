//
//  ItemsFetcherContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 15.06.2022.
//

import Foundation

protocol ItemsFetcherContext {
    func fetchItems<ResultController: ResultControllerContext>(
        using resultController: ResultController,
        parentFolderId: String
    ) where ResultController.ResultType == Item
}
