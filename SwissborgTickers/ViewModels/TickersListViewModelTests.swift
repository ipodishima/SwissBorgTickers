//
//  TickersListViewModelTests.swift
//  SwissborgTickersTests
//
//  Created by Marian Paul on 2022-04-19.
//

import Moya
@testable import SwissborgTickers
import XCTest
import RxTest

class TickersListViewModelTests: XCTestCase {
    
    func test_startPolling_whenCalled_immediatelyFetchesTheAPI() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.success(tickers: [.btc])])
        let sut = TickersListViewModel(provider: stubProvider)
        let statePublisher = sut.$state
            .collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        let states = try awaitPublisher(statePublisher)
        XCTAssertEqual(states, [.loading, .loaded])
    }
    
    func test_startPolling_whenCalledAndAPIReturnsAnError_returnsAnErrorState() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.networkError(URLError(.badURL) as NSError)])
        let sut = TickersListViewModel(provider: stubProvider)
        let statePublisher = sut.$state.collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        let states = try awaitPublisher(statePublisher)
        XCTAssertEqual(states, [.loading, .failed(URLError(.badURL), context: .initial)])
    }
    
    func test_startPolling_whenPollingIsHappening_callsTheAPI() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.success(tickers: [.btc]),
                                                         .success(tickers: [.btc])])
        let scheduler = TestScheduler(initialClock: 0)
        let sut = TickersListViewModel(provider: stubProvider, scheduler: scheduler)
        var statePublisher = sut.$state.collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        scheduler.advanceTo(4)
        var states = try awaitPublisher(statePublisher)
        XCTAssertEqual(states, [.loading, .loaded])
        
        statePublisher = sut.$state.collectNext(2)
        scheduler.advanceTo(5)
        states = try awaitPublisher(statePublisher)
        XCTAssertEqual(states, [.refreshing, .loaded])
    }
    
    func test_startPolling_whenAnErrorOccurred_recallTheAPI() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.success(tickers: [.btc]),
                                                         .networkError(URLError(.badURL) as NSError),
                                                         .success(tickers: [.btc])])
        let scheduler = TestScheduler(initialClock: 0)
        let sut = TickersListViewModel(provider: stubProvider, scheduler: scheduler)
        var statePublisher = sut.$state.collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        scheduler.advanceTo(4)
        var states = try awaitPublisher(statePublisher)
        XCTAssertEqual(states, [.loading, .loaded])
        
        statePublisher = sut.$state.collectNext(2)
        scheduler.advanceTo(5)
        states = try awaitPublisher(statePublisher)
        XCTAssertEqual(states, [.refreshing, .failed(URLError(.badURL), context: .refresh)])
        
        statePublisher = sut.$state.collectNext(2)
        scheduler.advanceTo(10)
        states = try awaitPublisher(statePublisher)
        XCTAssertEqual(states, [.refreshing, .loaded])
    }
    
    func test_startPolling_whenDataIsNotATicker_returnsAnError() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.networkResponse(200, Data())])
        let sut = TickersListViewModel(provider: stubProvider)
        let statePublisher = sut.$state
            .collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        let states = try awaitPublisher(statePublisher)
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: NSError(domain: NSCocoaErrorDomain, code: 3840, userInfo: [debugDescription: "Unable to parse empty data."])))
        let expectedError = MoyaError.objectMapping(decodingError, Response(statusCode: 200, data: Data()))
        XCTAssertEqual(states, [.loading, .failed(expectedError, context: .initial)])
    }
    
    func test_toDisplay_whenTheAPIReturnsTickers_returnsTheExpectedValue() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.success(tickers: [.btc, .eth])])
        let sut = TickersListViewModel(provider: stubProvider)
        let toDisplayPublisher = sut.$toDisplay
            .collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        let toDisplay = try awaitPublisher(toDisplayPublisher)
        let expectedToDisplay: [TickersListViewModel.TickerDataObject] = [.init(ticker: .btc,
                                                                                isEarnYield: true,
                                                                                graphValues: FakeGraphValue.eth.values),
                                                                          .init(ticker: .eth,
                                                                                isEarnYield: false,
                                                                                graphValues: [])]
        XCTAssertEqual(toDisplay, [[], expectedToDisplay])
    }
    
    func test_toDisplay_whenSearchIsNotEmpty_filtersTheValues() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.success(tickers: [.btc, .eth])])
        let sut = TickersListViewModel(provider: stubProvider)
        sut.searchText = "eth"
        let toDisplayPublisher = sut.$toDisplay
            .collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        let toDisplay = try awaitPublisher(toDisplayPublisher)
        let expectedToDisplay: [TickersListViewModel.TickerDataObject] = [.init(ticker: .eth,
                                                                                isEarnYield: true,
                                                                                graphValues: [])]
        XCTAssertEqual(toDisplay, [[], expectedToDisplay])
    }
    
    func test_toDisplay_whenSearchIsNotEmpty_returnsNoGraph() throws {
        // Arrange
        let stubProvider = buildStubProvider(responses: [.success(tickers: [.btc, .eth])])
        let sut = TickersListViewModel(provider: stubProvider)
        sut.searchText = "btc"
        let toDisplayPublisher = sut.$toDisplay
            .collectNext(2)
        
        // Act
        sut.startPolling()
        
        // Assert
        let toDisplay = try awaitPublisher(toDisplayPublisher)
        let expectedToDisplay: [TickersListViewModel.TickerDataObject] = [.init(ticker: .btc,
                                                                                isEarnYield: true,
                                                                                graphValues: [])]
        XCTAssertEqual(toDisplay, [[], expectedToDisplay])
    }
    
    // MARK: - private
    
    private func buildStubProvider(responses: [EndpointSampleResponse]) -> MoyaProvider<BitFinexService> {
        var responses = responses
        return .init(endpointClosure: { target in
            return .init(url: target.path,
                         sampleResponseClosure: {
                if responses.count > 1 {
                    return responses.removeFirst()
                } else {
                    return responses[0]
                }
            },
                         method: target.method,
                         task: target.task,
                         httpHeaderFields: target.headers)
        },
                     stubClosure: { _ in .immediate },
                     callbackQueue: .main) // If we don't specify a main queue, tests are failing. Probably a race condition
    }
}

// MARK: - Helpers

extension EndpointSampleResponse {
    static func success(tickers: [Ticker]) -> EndpointSampleResponse {
        let data = (try? JSONEncoder().encode(tickers)) ?? Data()
        return .networkResponse(200, data)
    }
}

extension Ticker: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(symbol.rawValue)
        try container.encode(bid)
        try container.encode(bidSize)
        try container.encode(ask)
        try container.encode(askSize)
        try container.encode(dailyChange)
        try container.encode(dailyChangeRelative)
        try container.encode(lastPrice)
        try container.encode(volume)
        try container.encode(high)
        try container.encode(low)
    }
}

extension Ticker {
    static var btc: Ticker {
        let json = "[\"tBTCUSD\",41407,14.84271529,41412,21.529516170000004,117.88468987,0.0029,41407.1403608,2345.67160835,41777,40601]"
        return Ticker.from(json: json)
    }
    
    static var eth: Ticker {
        let json = "[\"tETHUSD\",41407,14.84271529,41412,21.529516170000004,117.88468987,0.0029,41407.1403608,2345.67160835,41777,40601]"
        return Ticker.from(json: json)
    }
}

// Equatables implementation should be generated using Sourcery

extension PollingLoadingState: Equatable {
    
    public static func == (lhs: PollingLoadingState, rhs: PollingLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.refreshing, .refreshing): return true
        case let (.failed(lhsError, lhsContext), .failed(rhsError, rhsContext)): return lhsError.localizedDescription == rhsError.localizedDescription && lhsContext == rhsContext
        case (.loaded, .loaded): return true
        default: return false
        }
    }
}

extension Ticker: Equatable {
    public static func == (lhs: Ticker, rhs: Ticker) -> Bool {
        return lhs.symbol == rhs.symbol
        &&
        lhs.bid == rhs.bid
        &&
        lhs.bidSize == rhs.bidSize
        &&
        lhs.ask == rhs.ask
        &&
        lhs.askSize == rhs.askSize
        &&
        lhs.dailyChange == rhs.dailyChange
        &&
        lhs.dailyChangeRelative == rhs.dailyChangeRelative
        &&
        lhs.lastPrice == rhs.lastPrice
        &&
        lhs.volume == rhs.volume
        &&
        lhs.high == rhs.high
        &&
        lhs.low == rhs.low
    }
}
extension TickersListViewModel.TickerDataObject: Equatable {
    public static func == (lhs: TickersListViewModel.TickerDataObject, rhs: TickersListViewModel.TickerDataObject) -> Bool {
        lhs.ticker == rhs.ticker
        &&
        lhs.isEarnYield == rhs.isEarnYield
        &&
        lhs.graphValues == rhs.graphValues
    }
}
