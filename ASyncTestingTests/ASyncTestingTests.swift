//
//  ASyncTestingTests.swift
//  ASyncTestingTests
//
//  Created by seokho on 2022/05/17.
//

import XCTest
@testable import ASyncTesting

class HelloWorldProviderTests: XCTestCase {
    var result: String?
    
    let expectation = XCTestExpectation()
    
    func test_HelloWorldProvider() {
        
        HelloWorldProvider.asyncHelloWorld { [weak self] str in
            self?.result = str
            self?.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)

        XCTAssertNotNil(result)
    }
}
