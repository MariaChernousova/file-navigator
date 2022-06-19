//
//  FileViewModelTest.swift
//  file-managerTests
//
//  Created by Chernousova Maria on 18.06.2022.
//

import XCTest
@testable import file_manager

class FileViewModelTest: XCTestCase {
    private enum Constant {
        static let timeout: TimeInterval = 0.1
    }
    
    var model: FileModelMock!
    var viewModel: FileViewModel!
    
    override func setUp() {
        super.setUp()
        model = FileModelMock()
    }
    
    func test_didLoad() {
        // Prepare.
        model.fileAdapter = FileAdapterFake.file
        viewModel = FileViewModel(fileId: FileAdapterFake.file.id, model: model)
        
        // Act.
        viewModel.didLoad()
        
        // Assert.
        XCTAssertEqual(model.fileAdapter!.id, FileAdapterFake.file.id)
    }

}
