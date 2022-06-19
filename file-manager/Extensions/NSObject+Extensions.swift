//
//  NSObject+Extensions.swift
//  file-manager
//
//  Created by Chernousova Maria on 14.06.2022.
//

import Foundation

extension NSObject {
    static var identifier: String {
        "\(String(describing: self))Identifier"
    }
}
