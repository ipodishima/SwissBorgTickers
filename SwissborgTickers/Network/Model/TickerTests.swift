//
//  TickerTests.swift
//  SwissborgTickersTests
//
//  Created by Marian Paul on 2022-04-17.
//

@testable import SwissborgTickers
import XCTest

class TickerTests: XCTestCase {

    func test_decodable_whenCalled_decodesCorrectly() throws {
        // Arrange
        let json = "[\"tBTCUSD\",10654,53.62425959,10655,76.68743116,745.1,0.0752,10655,14420.34271146,10766,9889.1449809]"
        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoder = JSONDecoder()
        
        // Act
        let sut = try decoder.decode(Ticker.self, from: data)
        
        // Assert
        let epsilon: Float = 0.0001
        XCTAssertEqual(sut.symbol.rawValue, "tBTCUSD")
        XCTAssertEqual(sut.bid, 10654, accuracy: epsilon)
        XCTAssertEqual(sut.bidSize, 53.62425959, accuracy: epsilon)
        XCTAssertEqual(sut.ask, 10655, accuracy: epsilon)
        XCTAssertEqual(sut.askSize, 76.68743116, accuracy: epsilon)
        XCTAssertEqual(sut.dailyChange, 745.1, accuracy: epsilon)
        XCTAssertEqual(sut.dailyChangeRelative, 0.0752, accuracy: epsilon)
        XCTAssertEqual(sut.lastPrice, 10655, accuracy: epsilon)
        XCTAssertEqual(sut.volume, 14420.34271146, accuracy: epsilon)
        XCTAssertEqual(sut.high, 10766, accuracy: epsilon)
        XCTAssertEqual(sut.low, 9889.1449809, accuracy: epsilon)
    }

}
