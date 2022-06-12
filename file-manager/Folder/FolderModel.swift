//
//  FolderModel.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation
import CoreData

protocol FolderModelProvider {
    func loadData()
}

class FolderModel: FolderModelProvider {

    private let coreDataBase: CoreDataBaseContext
    private let networkManager: NetworkManagerContext
      
    init(serviceManager: ServiceManager) {
        self.coreDataBase = serviceManager.coreDataBase
        self.networkManager = serviceManager.networkManager
    }
    
    func loadData() {
        networkManager.loadData()
    }
}
