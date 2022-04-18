//
//  BitFinexEnvironmentTests.swift
//  SwissborgTickersTests
//
//  Created by Marian Paul on 2022-04-17.
//

@testable import SwissborgTickers
import XCTest

class BitFinexEnvironmentTests: XCTestCase {

    func test_baseURL_whenEnvironmentIsProduction_returnsTheExpectedURL() throws {
        // Arrange
        let sut = BitFinexEnvironment.production
        
        // Act
        let baseURL = sut.baseURL
        
        // Assert
        let expectedURL = try XCTUnwrap(URL(string: "https://api-pub.bitfinex.com/v2"))
        XCTAssertEqual(baseURL, expectedURL)
    }

}
