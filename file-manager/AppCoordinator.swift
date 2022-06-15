//
//  AppCoordinator.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class AppCoordinator: Coordinator {
    var serviceManager: ServiceManager
    var rootViewController: UINavigationController
    
    init(serviceManager: ServiceManager, rootViewController: UINavigationController) {
        self.serviceManager = serviceManager
        self.rootViewController = rootViewController
    }
    
    func start() {
        startFoldersCoordinator()
    }
    
    private func startFoldersCoordinator() {
        FolderCoordinator(serviceManager: serviceManager, rootViewController: rootViewController, folderId: nil).start()
    }
}
