//
//  Float+ExtensionsTests.swift
//  SwissborgTickersTests
//
//  Created by Marian Paul on 2022-04-18.
//

import XCTest
@testable import SwissborgTickers

class Float_ExtensionsTests: XCTestCase {

    func test_asPercentageWithExplicitSign_whenIsNegative_returnsAsExpected() {
        // Arrange
        let sut: Float = -0.123
        
        // Act
        let formatted = sut.asPercentageWithExplicitSign
        
        // Assert
        XCTAssertEqual(formatted, "-12.3 %")
    }
    
    func test_asPercentageWithExplicitSign_whenIsPositive_returnsAsExpected() {
        // Arrange
        let sut: Float = 0.123
        
        // Act
        let formatted = sut.asPercentageWithExplicitSign
        
        // Assert
        XCTAssertEqual(formatted, "+12.3 %")
    }

}
