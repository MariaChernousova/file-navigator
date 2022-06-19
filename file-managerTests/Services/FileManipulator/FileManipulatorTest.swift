//
//  FileManipulatorTest.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 19.06.2022.
//

import XCTest
@testable import file_manager

class FileManipulatorTest: XCTestCase {
    private enum Constant {
        static let timeout: TimeInterval = 0.1
    }
    
    var fileManipulator: FileManipulator!
    var coreDataBaseMock: FileManipulatorCoreDataBaseMock!
    
    override func setUp() {
        super.setUp()
        coreDataBaseMock = FileManipulatorCoreDataBaseMock()
        fileManipulator = FileManipulator(coreDataBase: coreDataBaseMock)
    }
    
    func test_fetchFile_id_success_noItems() {
        // Prepare.
        let id = UUID().uuidString
        let context = FileManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.files = []
        coreDataBaseMock.context = context
        
        // Act.
        let result = fileManipulator.fetchFile(id: id)
        
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

    func test_fetchFile_id_failure() {
        // Prepare.
        let id = UUID().uuidString
        let context = FileManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.files = []
        coreDataBaseMock.context = context
        coreDataBaseMock.fetchError = .unknown
        
        // Act.
        let result = fileManipulator.fetchFile(id: id)
        
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
    
    func test_fetchFile_ID_success_noItems() {
        // Prepare.
        let id = UUID().uuidString
        let context = FileManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.files = []
        coreDataBaseMock.context = context
        
        // Act.
        let result = fileManipulator.fetchFile(ID: id)
        
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
    
    func test_fetchFile_ID_success_idIsNil() {
        // Prepare.
        let context = FileManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", NSNull())
        coreDataBaseMock.files = []
        coreDataBaseMock.context = context
        
        // Act.
        let result = fileManipulator.fetchFile(ID: nil)
        
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
    
    func test_fetchFile_ID_failure() {
        // Prepare.
        let id = UUID().uuidString
        let context = FileManipulatorManageObjectContextFake.empty
        let predicate = NSPredicate(format: "%K == %@", "id", id)
        coreDataBaseMock.files = []
        coreDataBaseMock.context = context
        coreDataBaseMock.fetchError = .unknown
        
        // Act.
        let result = fileManipulator.fetchFile(ID: id)
        
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
