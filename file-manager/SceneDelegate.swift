//
//  SceneDelegate.swift
//  file-manager
//
//  Created by Chernousova Maria on 06.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private(set) var appCoordinator: AppCoordinator?
    
    private lazy var serviceLocator = ServiceLocator()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        
        configureCoreData()
        configureNetworkManager()
        
        appCoordinator = AppCoordinator(serviceManager: serviceLocator, rootViewController: navigationController)
        appCoordinator?.start()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

extension SceneDelegate {
    
    private func configureCoreData() {
        typealias CoreDataBaseType = CoreDataBaseContext & RestrictedCoreDataBaseContext
        typealias FolderManipulatorType = FolderManipulatorContext & RestrictedFolderManipulatorContext
        typealias FileManipulatorType = FileManipulatorContext & RestrictedFileManipulatorContext
        
        // Core Data elements.
        let coreDataBase: CoreDataBaseType = CoreDataBase(modelName: "file_manager")
        let managedObjectBuilder: ManagedObjectBuilderContext = ManagedObjectBuilder()
        
        // Data Manipulators.
        let itemManipulator = ItemManipulator(coreDataBase: coreDataBase)
        let fileManipulator = FileManipulator(coreDataBase: coreDataBase)
        let folderManipulator = FolderManipulator(coreDataBase: coreDataBase)
        
        // Data managers.
        let dataManager: DataManagerContext = DataManager(
            coreDataBase: coreDataBase,
            managedObjectBuilder: managedObjectBuilder,
            folderManipulator: folderManipulator,
            fileManipulator: fileManipulator
        )
        
        // Registration.
        serviceLocator.register(coreDataBase)
        serviceLocator.register(managedObjectBuilder)
        serviceLocator.register(itemManipulator as ItemManipulatorContext)
        serviceLocator.register(fileManipulator as FileManipulatorContext)
        serviceLocator.register(folderManipulator as FolderManipulatorContext)
        serviceLocator.register(dataManager)
    }
    
    private func configureNetworkManager() {
        let networkManager: NetworkManagerContext = NetworkManager()
        serviceLocator.register(networkManager)
    }
}
