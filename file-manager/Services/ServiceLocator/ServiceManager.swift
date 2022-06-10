//
//  ServiceManager.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

protocol ServiceManager {
    var coreDataBase: CoreDataBaseContext { get }
    var networkManager: NetworkManagerContext { get }
}
