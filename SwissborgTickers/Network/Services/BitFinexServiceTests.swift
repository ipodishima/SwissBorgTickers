//
//  BitFinexServiceTests.swift
//  SwissborgTickersTests
//
//  Created by Marian Paul on 2022-04-17.
//

import Moya
@testable import SwissborgTickers
import XCTest

class BitFinexServiceTests: XCTestCase {

    func test_baseURL_whenCalled_returnsTheExpectedValue() {
        // Arrange
        let injectedEnvironment = BitFinexEnvironment.production
        // Note: we should inject AppSettings.currentBitFinexEnvironment here. Not done for this test
        let sut = BitFinexService.tickers(symbols: [.tAAVEUSD])
        
        // Act
        let baseURL = sut.baseURL
        
        // Assert
        XCTAssertEqual(baseURL, injectedEnvironment.baseURL)
    }
    
    func test_path_whenEndpointIsTickers_returnsTheExpectedValue() {
        // Arrange
        let sut = BitFinexService.tickers(symbols: [.tAAVEUSD])
        
        // Act
        let path = sut.path
        
        // Assert
        XCTAssertEqual(path, "/tickers")
    }
    
    func test_method_whenEndpointIsTickers_returnsTheExpectedValue() {
        // Arrange
        let sut = BitFinexService.tickers(symbols: [.tAAVEUSD])
        
        // Act
        let method = sut.method
        
        // Assert
        XCTAssertEqual(method, .get)
    }
    
    func test_task_whenEndpointIsTickersAndSymbolsIsUnique_returnsTheExpectedValue() throws {
        // Arrange
        let sut = BitFinexService.tickers(symbols: [.tAAVEUSD])
        
        // Act
        let task = sut.task
        
        // Assert
        guard case let .requestParameters(parameters, encoding) = task else {
            XCTFail("Expecting `requestParameters`, got `\(task)`")
            return
        }
        
        let stringParameters = try XCTUnwrap(parameters as? [String: String])
        XCTAssertEqual(stringParameters, ["symbols": "tAAVE:USD"])
        let urlEncoding = try XCTUnwrap(encoding as? URLEncoding)
        guard case .queryString = urlEncoding.destination else {
            XCTFail("Expecting `queryString`, got `\(urlEncoding)`")
            return
        }
    }
    
    func test_task_whenEndpointIsTickersAndSymbolsAreMultiple_returnsTheExpectedValue() throws {
        // Arrange
        let sut = BitFinexService.tickers(symbols: [.tAAVEUSD, .tBTCUSD])
        
        // Act
        let task = sut.task
        
        // Assert
        guard case let .requestParameters(parameters, _) = task else {
            XCTFail("Expecting `requestParameters`, got `\(task)`")
            return
        }
        
        let stringParameters = try XCTUnwrap(parameters as? [String: String])
        XCTAssertEqual(stringParameters, ["symbols": "tAAVE:USD,tBTCUSD"])
    }

    func test_headers_whenEndpointIsTickers_returnsTheExpectedValue() {
        // Arrange
        let sut = BitFinexService.tickers(symbols: [.tAAVEUSD])
        
        // Act
        let headers = sut.headers
        
        // Assert
        XCTAssertNil(headers)
    }
}
