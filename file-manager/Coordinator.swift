//
//  Coordinator.swift
//  file-manager
//
//  Created by Chernousova Maria on 10.06.2022.
//

import UIKit

protocol Coordinator {
    var serviceManager: ServiceManager { get }
    var rootViewController: UINavigationController { get }
    func start()
}
