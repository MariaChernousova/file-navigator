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
    private let file: File
    
    init(serviceManager: ServiceManager, rootViewController: UINavigationController, file: File) {
        self.serviceManager = serviceManager
        self.rootViewController = rootViewController
        self.file = file
    }
    
    func start() {
        let model = FileModel()
        let viewModel = FileViewModel(file: file, model: model)
        let viewController = FileViewController(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
    }
}
