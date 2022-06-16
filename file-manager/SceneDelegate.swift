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
        
        configureCoreDataBase()
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
    private func configureCoreDataBase() {
        let coreDataBase: CoreDataBaseContext = CoreDataBase(modelName: "file_manager")
        
        let itemsFetcher: ItemsFetcherContext = ItemsFetcher(coreDataBaseContext: coreDataBase)
        serviceLocator.register(itemsFetcher)
        let fileFetcher: FileFetcherContext = FileFetcher(coreDataBase: coreDataBase)
        serviceLocator.register(fileFetcher)
        let dataManager: DataManagerContext = DataManager(coreDataBase: coreDataBase)
        serviceLocator.register(dataManager)
    }
    
    private func configureNetworkManager() {
        let networkManager: NetworkManagerContext = NetworkManager()
        serviceLocator.register(networkManager)
    }
}
