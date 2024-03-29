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
    
    let serviceManager: ServiceManager
    let rootViewController: UINavigationController
    private let folderId: String?
    
    init(serviceManager: ServiceManager, rootViewController: UINavigationController, folderId: String?) {
        self.serviceManager = serviceManager
        self.rootViewController = rootViewController
        self.folderId = folderId
    }
    
    func start() {
        let model = FolderModel(serviceManager: serviceManager)
        let viewModel = FolderViewModel(folderId: folderId, model: model) { path in
            switch path {
            case .folder(let id):
                self.startFolderFlow(with: id)
            case .file(let id):
                self.startFileFlow(with: id)
            }
        }
        
        let viewController = FolderViewController(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    private func startFolderFlow(with folderID: String) {
        FolderCoordinator(serviceManager: serviceManager, rootViewController: rootViewController, folderId: folderID).start()
    }
    
    private func startFileFlow(with fileID: String) {
        FileCoordinator(serviceManager: serviceManager, rootViewController: rootViewController, fileId: fileID).start()
    }
}
