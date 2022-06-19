//
//  FolderManipulatorTest.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import XCTest
@testable import file_manager

class FolderManipulatorTest: XCTestCase {
    private enum Constant {
        static let timeout: TimeInterval = 0.1
    }
    
    var folderManipulator: FolderManipulator!
    var coreDataBaseMock: FolderManipulatorCoreDataBaseMock!
    
    override func setUp() {
        super.setUp()
        coreDataBaseMock = FolderManipulatorCoreDataBaseMock()
        folderManipulator = FolderManipulator(coreDataBase: coreDataBaseMock)
    }
    
    func test_fetchFolder_id_success_noItems() {
        // Prepare.
        let id = UUID().uuidString
        let context = FolderManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.folders = []
        coreDataBaseMock.context = context

        // Act.
        let result = folderManipulator.fetchFolder(id: id)
        
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
    
    func test_fetchFolder_id_failure() {
        // Prepare.
        let id = UUID().uuidString
        let context = FolderManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.folders = []
        coreDataBaseMock.context = context
        coreDataBaseMock.fetchError = .unknown
        
        // Act.
        let result = folderManipulator.fetchFolder(id: id)
        
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
    
    func test_fetchFolder_ID_success_noItems() {
        // Prepare.
        let id = UUID().uuidString
        let context = FolderManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.folders = []
        coreDataBaseMock.context = context
        
        // Act.
        let result = folderManipulator.fetchFolder(ID: id)
        
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
    
    func test_fetchFolder_ID_success_idIsNil() {
        // Prepare.
        let context = FolderManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", NSNull())
        coreDataBaseMock.folders = []
        coreDataBaseMock.context = context
        
        // Act.
        let result = folderManipulator.fetchFolder(ID: nil)
        
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
    
    func test_fetchFolder_ID_failure() {
        // Prepare.
        let id = UUID().uuidString
        let context = FolderManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.folders = []
        coreDataBaseMock.context = context
        coreDataBaseMock.fetchError = .unknown
        
        // Act.
        let result = folderManipulator.fetchFolder(ID: id)
    
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
}
