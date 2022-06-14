//
//  FetchResultControllerContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 13.06.2022.
//

import UIKit
import CoreData

typealias ItemsFetcherDataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>
typealias ItemsFetcherSnapshot = NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>

typealias ItemsFetcherUpdateHandler = (Result<ItemsFetcherSnapshot, NSError>) -> Void

protocol ItemsFetcherContext {
    func fetchItems(with parentFolderId: String,
                    updateHandler: @escaping ItemsFetcherUpdateHandler)
}
