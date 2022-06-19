//
//  ItemResultControllerMock.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import XCTest
import CoreData

@testable import file_manager


class ItemResultControllerMock: ResultControllerContext {
    
    var fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    
    var receivedContext: NSManagedObjectContext?
    
    var performFetchExpectation: XCTestExpectation?
    
    func performFetch(with context: NSManagedObjectContext) {
        receivedContext = context
        performFetchExpectation?.fulfill()
    }
}
