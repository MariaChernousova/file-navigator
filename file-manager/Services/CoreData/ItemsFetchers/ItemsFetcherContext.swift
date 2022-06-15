//
//  ItemsFetcherContext.swift
//  file-manager
//
//  Created by Eric Golovin on 6/15/22.
//

import Foundation

protocol ItemsFetcherContext {
    func fetchItems<ResultController: ResultControllerContext>(
        using resultController: ResultController,
        parentFolderId: String
    ) where ResultController.ResultType == Item
}
