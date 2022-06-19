//
//  FolderViewModelTest.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 17.06.2022.
//

import XCTest
@testable import file_manager

class FolderViewModelTest: XCTestCase {
    private enum Constant {
        static let timeout: TimeInterval = 0.1
    }
    
    var model: FolderModelMock!
    var viewModel: FolderViewModel!
    
    override func setUp() {
        super.setUp()
        
        model = FolderModelMock()
    }
    
    func test_didLoad_NoFolderId() {
        // Prepare.
        model.items = FolderAdapterFake.items
        model.spreadSheet = SpreadSheetFake.empty
        viewModel = FolderViewModel(folderId: nil, model: model) { _ in }
        
        weak var expectation = expectation(description: "Snapshot has been provided.")
        var snapshot: ItemsResultSnapshot?
        viewModel.setUpdateHandler { newSnapshot in
            snapshot = newSnapshot
            guard let newExpectation = expectation else { return }
            newExpectation.fulfill()
            expectation = nil
        }
        
        // Act.
        viewModel.didLoad()
        
        // Assert.
        waitForExpectations(timeout: Constant.timeout, handler: nil)
        XCTAssertNotNil(snapshot)
    }
    
        func test_didLoad_FolderId() {
            // Prepare.
            model.items = FolderAdapterFake.items
            model.spreadSheet = SpreadSheetFake.empty
            viewModel = FolderViewModel(folderId: FolderAdapterFake.parentFolder.id, model: model) { _ in }
    
            weak var expectation = expectation(description: "Snapshot has been provided.")
            var snapshot: ItemsResultSnapshot?
            viewModel.setUpdateHandler { newSnapshot in
                snapshot = newSnapshot
                guard let newExpectation = expectation else { return }
                newExpectation.fulfill()
                expectation = nil
            }
    
            // Act.
            viewModel.didLoad()
    
            // Assert.
            waitForExpectations(timeout: Constant.timeout, handler: nil)
            XCTAssertNotNil(snapshot)
        }
    
    func test_selectItem_Folder() {
        // Prepare.
        model.items = FolderAdapterFake.items
        model.spreadSheet = SpreadSheetFake.empty
        
        let expectation = expectation(description: "Folder select has been provided.")
        let resultFolderAdapter = FolderAdapterFake.folder1
        var selectedFolderId: String?
        viewModel = FolderViewModel(folderId: nil, model: model) { path in
            switch path {
            case .file:
                break
            case .folder(let id):
                selectedFolderId = id
                expectation.fulfill()
            }
        }
        
        // Act.
        viewModel.select(item: resultFolderAdapter)
        
        // Assert.
        wait(for: [expectation], timeout: Constant.timeout)
        XCTAssertNotNil(selectedFolderId)
        XCTAssertEqual(selectedFolderId!, resultFolderAdapter.id)
    }
    
    func test_selectItem_File() {
        // Prepare.
        model.items = FolderAdapterFake.items
        model.spreadSheet = SpreadSheetFake.empty
        
        let expectation = expectation(description: "File select has been provided.")
        let resultFolderAdapter = FolderAdapterFake.file1
        var selectedFileId: String?
        viewModel = FolderViewModel(folderId: nil, model: model) { path in
            switch path {
            case .file(let id):
                selectedFileId = id
                expectation.fulfill()
            case .folder:
                break
            }
        }
        
        // Act.
        viewModel.select(item: resultFolderAdapter)
        
        // Assert.
        wait(for: [expectation], timeout: Constant.timeout)
        XCTAssertNotNil(selectedFileId)
        XCTAssertEqual(selectedFileId!, resultFolderAdapter.id)
    }
}
