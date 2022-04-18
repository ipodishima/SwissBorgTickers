//
//  String+ExtensionsTests.swift
//  SwissborgTickersTests
//
//  Created by Marian Paul on 2022-04-17.
//

@testable import SwissborgTickers
import XCTest

class String_ExtensionsTests: XCTestCase {

    func test_prefixIfNeeded_whenSelfAlreadyHasThePrefix_doesNotPrefixIt() {
        // Arrange
        let sut = "/path"
        
        // Act
        let prefixed = sut.prefixIfNeeded(with: "/")
        
        // Assert
        XCTAssertEqual(prefixed, "/path")
    }
    
    func test_prefixIfNeeded_whenSelfDoesNotHaveThePrefix_prefixesIt() {
        // Arrange
        let sut = "path"
        
        // Act
        let prefixed = sut.prefixIfNeeded(with: "/")
        
        // Assert
        XCTAssertEqual(prefixed, "/path")
    }

}
