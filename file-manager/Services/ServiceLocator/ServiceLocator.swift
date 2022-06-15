//
//  ServiceLocator.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import Foundation

class ServiceLocator {
    private var services = [ObjectIdentifier: Any]()
    
    func register<T>(_ service: T) {
        services[key(for: T.self)] = service
    }
    
    func resolve<T>() -> T? {
        return services[key(for: T.self)] as? T
    }
    
    private func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}

extension ServiceLocator: ServiceManager {
    private enum Const {
        static let errorMessage = "'%@' cannot be resolved"
    }
    
    var itemsFetcher: ItemsFetcherContext {
        guard let itemsFetcher: ItemsFetcherContext = resolve() else {
            fatalError(.init(format: Const.errorMessage,
                             arguments: [String(describing: ItemsFetcherContext.self)]))
        }
        return itemsFetcher
    }
    
    var fileFetcher: FileFetcherContext {
        guard let fileFetcher: FileFetcherContext = resolve() else {
            fatalError(.init(format: Const.errorMessage,
                             arguments: [String(describing: FileFetcherContext.self)]))
        }
        return fileFetcher
    }
    
    var networkManager: NetworkManagerContext {
        guard let networkManager: NetworkManagerContext = resolve() else {
            fatalError(.init(format: Const.errorMessage,
                             arguments: [String(describing: NetworkManagerContext.self)]))
        }
        return networkManager
    }
    
    var dataManager: DataManagerContext {
        guard let dataManager: DataManagerContext = resolve() else {
            fatalError(.init(format: Const.errorMessage,
                             arguments: [String(describing: DataManagerContext.self)]))
        }
        return dataManager
    }
}
