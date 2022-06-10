//
//  FolderCoordinator.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FolderCoordinator: Coordinator {
    enum Path {
        case folder(id: String)
        case file(id: String)
    }
    
    var serviceManager: ServiceManager
    
    var rootViewController: UINavigationController
    
    init(serviceManager: ServiceManager, rootViewController: UINavigationController) {
        self.serviceManager = serviceManager
        self.rootViewController = rootViewController
    }
    
    func start() {
        
    }
    
    
}
