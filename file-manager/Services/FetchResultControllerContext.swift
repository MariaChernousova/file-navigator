//
//  FetchResultControllerContext.swift
//  file-manager
//
//  Created by Eric Golovin on 13.06.2022.
//

import UIKit

typealias ItemsFetcherDataSource = UICollectionViewDiffableDataSource<Int, Item>
typealias ItemsFetcherSnapshot = NSDiffableDataSourceSnapshot<Int, Item>

typealias ItemsFetcherUpdateHandler = (Result<ItemsFetcherSnapshot, NSError>) -> Void

protocol ItemsFetcherContext {
    func fetchItems(with parentFolderId: String,
                    updateHandler: @escaping ItemsFetcherUpdateHandler)
}
