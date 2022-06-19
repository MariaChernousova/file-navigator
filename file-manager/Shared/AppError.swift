//
//  AppError.swift
//  file-manager
//
//  Created by Chernousova Maria on 16.06.2022.
//

import Foundation

enum AppError: Error {
    case undefined
    case dataNotFound
    case networkIssue
    case systemError(NSError)
    
    init(_ error: CoreDataBaseError) {
        switch error {
        case .unknown:
            self = .undefined
        case .systemError(let systemError):
            self = .systemError(systemError)
        }
    }
    
    var title: String {
        switch self {
        case .undefined:
            return "Undefined Error"
        case .dataNotFound:
            return "No Data Found Error"
        case .networkIssue:
            return "Network Issue Error"
        case .systemError:
            return "System Error"
        }
    }
    
    var description: String {
        switch self {
        case .undefined:
            return "Error cannot be defined."
        case .dataNotFound:
            return "No data found in the database."
        case .networkIssue:
            return "Network connection issue happened."
        case .systemError:
            return "System reports of an issue."
        }
    }
}
