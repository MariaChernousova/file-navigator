//
//  FileCoordinator.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

class FileCoordinator: Coordinator {
    var serviceManager: ServiceManager
    var rootViewController: UINavigationController
    private let fileId: String
    
    init(serviceManager: ServiceManager, rootViewController: UINavigationController, fileId: String) {
        self.serviceManager = serviceManager
        self.rootViewController = rootViewController
        self.fileId = fileId
    }
    
    func start() {
        let model = FileModel(serviceManager: serviceManager)
        let viewModel = FileViewModel(fileId: fileId, model: model)
        let viewController = FileViewController(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
    }
}
