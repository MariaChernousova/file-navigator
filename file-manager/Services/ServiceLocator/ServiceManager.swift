//
//  ServiceManager.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol ServiceManager {
    var itemsFetcher: ItemsFetcherContext { get }
    var fileFetcher: FileFetcherContext { get }
    var networkManager: NetworkManagerContext { get }
    var dataManager: DataManagerContext { get }
}
