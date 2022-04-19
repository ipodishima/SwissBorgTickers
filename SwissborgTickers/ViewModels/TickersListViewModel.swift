//
//  TickersListViewModel.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import Combine
import Foundation
import Moya
import RxMoya
import RxSwift
import SwiftUI

protocol TickersListViewModelProtocol: ObservableObject {
    /// The current state
    var state: PollingLoadingState { get }
    
    /// Search text from the SearchBar
    var searchText: String { get set }
    
    /// Objects to display in the list
    var toDisplay: [TickersListViewModel.TickerDataObject] { get }
    
    /// Start polling the API
    func startPolling()
}

class TickersListViewModel: TickersListViewModelProtocol {
    private var lastTickers: [Ticker] = []
    private let provider = MoyaProvider<BitFinexService>()
    
    private var pollingDisposable: Disposable?
    
    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var toDisplay: [TickerDataObject] = []
    
    @Published var state: PollingLoadingState = .idle
    @Published var searchText: String = ""

    init() {
        bindSearch()
    }
    
    func startPolling() {
        // Cancel any previous polling
        pollingDisposable?.dispose()
        
        // Start a polling
        self.pollingDisposable = Observable<Int>
            .interval(.seconds(Constants.pollingInterval), scheduler: MainScheduler.instance)
            // Start now
            .startWith(0)
            // Update the loading state
            .do(onNext: { _ in
                self.state = self.lastTickers.isEmpty ? .loading : .refreshing
            })
            .flatMapLatest { _ in
                // Fetch the API and materialize to avoid ending the observable in case of an error
                self.provider.rx.request(.tickers(symbols: BitFinexService.TickerSymbol.allCases))
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { event in
                switch event {
                case .next(let response):
                    self.updateFromAPI(response: response)
                case .error(let error):
                    self.updateFromAPI(error: error)
                case .completed:
                    break
                }
            })
        
        self.pollingDisposable?
            .disposed(by: disposeBag)
    }
    
    private func updateFromAPI(response: Response) {
        do {
            let tickers = try response
                .filterSuccessfulStatusCodes()
                .map([Ticker].self)
            
            lastTickers = tickers
            updateFilteredTickers(searchText: searchText)
            state = .loaded
        } catch {
            updateFromAPI(error: error)
        }
    }
    
    private func updateFromAPI(error: Error) {
        state = .failed(error, context: lastTickers.isEmpty ? .initial : .refresh)
    }
    
    private func bindSearch() {
        $searchText
            .dropFirst()
            .sink { searchText in
                self.updateFilteredTickers(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func updateFilteredTickers(searchText: String) {
        toDisplay = lastTickers.filter {
            guard !searchText.isEmpty else { return true }
            return $0.symbol.symbol.localizedCaseInsensitiveContains(searchText)
        }
        .enumerated()
        .map {
            let graphValues: [Double]
            // We do not display the graph when searching
            if !searchText.isEmpty {
                graphValues = []
            } else {
                // Display each 8 rows the graph. Should be API driven obviously
                graphValues = $0.offset.isMultiple(of: 8) ? FakeGraphValue.eth.values : []
            }
            return TickerDataObject(ticker: $0.element,
                                    isEarnYield: $0.offset.isMultiple(of: 3),
                                    graphValues: graphValues)
        }
    }
    
    struct TickerDataObject: Identifiable {
        let ticker: Ticker
        let isEarnYield: Bool
        let graphValues: [Double]
        
        // MARK: - Identifiable
        
        var id: String {
            ticker.symbol.rawValue
        }
    }
    
    private enum Constants {
        static let pollingInterval = 5
    }
}
