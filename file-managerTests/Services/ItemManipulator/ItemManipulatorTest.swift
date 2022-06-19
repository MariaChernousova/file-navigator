//
//  ItemManipulatorTest.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import XCTest
@testable import file_manager

class ItemManipulatorTest: XCTestCase {
    private enum Constant {
        static let timeout: TimeInterval = 0.1
    }
    
    var itemManipulator: ItemManipulator!
    var coreDataBaseMock: ItemManipulatorCoreDataBaseMock!
    
    override func setUp() {
        super.setUp()
        coreDataBaseMock = ItemManipulatorCoreDataBaseMock()
        itemManipulator = ItemManipulator(coreDataBase: coreDataBaseMock)
    }
    
    func test_fetchItem_id_success() {
        // Prepare.
        let item = ItemManipulatorItemFake.item
        let context = ItemManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", item.id!)
        coreDataBaseMock.items = [item]
        coreDataBaseMock.mainContext = context
        
        // Act.
        let result = itemManipulator.fetchItem(with: item.id!)
        
        // Assert.
        switch result {
        case .success(let itemAdapter):
            XCTAssertEqual(itemAdapter.id, item.id)
            XCTAssertEqual(itemAdapter.title, item.title)
            XCTAssertEqual(itemAdapter.parentItemIdentifiers, item.parentItem?.id)
            XCTAssertEqual(coreDataBaseMock.receivedFetchRequest?.fetchLimit, 1)
            XCTAssertEqual(coreDataBaseMock.receivedFetchRequest?.predicate, predicate)
        case .failure:
            XCTFail("Shouldn't happen.")
        }
    }
    
    func test_fetchItem_id_success_noItems() {
        // Prepare.
        let context = ItemManipulatorManageObjectContextFake.empty
        let id = UUID().uuidString
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.items = []
        coreDataBaseMock.mainContext = context
        
        // Act.
        let result = itemManipulator.fetchItem(with: id)
        
        // Assert.
        switch result {
        case .success:
            XCTFail("Shouldn't happen.")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, AppError.dataNotFound.localizedDescription)
            XCTAssertEqual(coreDataBaseMock.receivedFetchRequest?.fetchLimit, 1)
            XCTAssertEqual(coreDataBaseMock.receivedFetchRequest?.predicate, predicate)
        }
    }
    
    func test_fetchItem_id_failure() {
        // Prepare.
        let context = ItemManipulatorManageObjectContextFake.empty
        let id = UUID().uuidString
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.items = []
        coreDataBaseMock.mainContext = context
        coreDataBaseMock.fetchError = .unknown
        
        // Act.
        let result = itemManipulator.fetchItem(with: id)
        
        // Assert.
        switch result {
        case .success:
            XCTFail("Shouldn't happen.")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, AppError.undefined.localizedDescription)
            XCTAssertEqual(coreDataBaseMock.receivedFetchRequest?.fetchLimit, 1)
            XCTAssertEqual(coreDataBaseMock.receivedFetchRequest?.predicate, predicate)
        }
    }
    
    func test_fetch_parentFolderId() {
        // Prepare.
        let resultController = ItemResultControllerMock()
        let id = UUID().uuidString
        let context = ItemManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "parentItem.id", id)
    
        let fetchExpectation = expectation(description: "Result controller has been fetched.")
        coreDataBaseMock.mainContext = context
        resultController.performFetchExpectation = fetchExpectation
        
        // Act.
        itemManipulator.fetchItems(using: resultController, parentFolderId: id)
        
        // Assert.
        wait(for: [fetchExpectation], timeout: Constant.timeout)
        XCTAssertEqual(resultController.fetchRequest.predicate, predicate)
        XCTAssertEqual(resultController.receivedContext, context)
    }
}
