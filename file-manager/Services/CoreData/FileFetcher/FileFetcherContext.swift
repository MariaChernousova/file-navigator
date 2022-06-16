//
//  FileFetcherContext.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

protocol FileFetcherContext {
    func fetchFile(fileId: String) -> File
}
