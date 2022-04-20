//
//  TickersList.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import SwiftUI
import RxSwift

struct TickersList<ViewModel: TickersListViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.state.isLoading {
                loadingView
            } else if viewModel.state.initialLoadingError != nil {
                initialLoadingErrorView
            } else {
                listView
            }
        }
        .onAppear(perform: viewModel.startPolling)
        .navigationBarItems(trailing: ProgressView()
                                .isHidden(!viewModel.state.isRefreshing))
    }
    
    @ViewBuilder private var loadingView: some View {
        ProgressView()
    }
    
    @ViewBuilder private var initialLoadingErrorView: some View {
        VStack {
            Text("error.initial.loading")
            Button("retry.action", action: viewModel.startPolling)
        }
    }
    
    @ViewBuilder private var listView: some View {
        VStack {
            if viewModel.state.pollingError != nil {
                Text("error.polling.try.again")
                    .foregroundColor(Theme.Color.error)
                    .font(Theme.Font.caption)
                    .padding()
            }
            
            List(viewModel.toDisplay) { dataObject in
                TickerView(ticker: dataObject.ticker,
                           isEarnYield: dataObject.isEarnYield,
                           graphValues: dataObject.graphValues)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 6)
            }
            .listStyle(.plain)
        }
        .navigationTitle("tickers.title")
        .searchable(text: $viewModel.searchText)
        .autocapitalization(.none)
        .refreshable {
            viewModel.startPolling()
        }
    }
}

#if DEBUG
struct TickersList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                TickersList(viewModel: DataSet.stubViewModel(state: .loaded, data: DataSet.tickersDataObject))
            }
            .previewDisplayName("Success")
            
            NavigationView {
                TickersList(viewModel: DataSet.stubViewModel(state: .failed(URLError(.badURL), context: .refresh), data: DataSet.tickersDataObject))
            }
            .previewDisplayName("Error on polling refresh")
            
            NavigationView {
                TickersList(viewModel: DataSet.stubViewModel(state: .failed(URLError(.badURL), context: .initial), data: []))
            }
            .previewDisplayName("Error on first refresh")
            
            NavigationView {
                TickersList(viewModel: DataSet.stubViewModel(state: .loading, data: []))
            }
            .previewDisplayName("Loading")
            
            NavigationView {
                TickersList(viewModel: DataSet.stubViewModel(state: .refreshing, data: DataSet.tickersDataObject))
            }
            .previewDisplayName("Refreshing")
        }
    }
    
    private enum DataSet {
        static func stubViewModel(state: PollingLoadingState, data: [TickersListViewModel.TickerDataObject]) -> StubTickersListViewModel {
            let viewModel = StubTickersListViewModel()
            viewModel.state = state
            viewModel.toDisplay = data
            return viewModel
        }
        
        static var tickersDataObject: [TickersListViewModel.TickerDataObject] {
            [.init(ticker: .from(json: "[\"tBTCUSD\",10654,53.62425959,10655,76.68743116,745.1,0.0752,10655,14420.34271146,10766,9889.1449809]"),
                   isEarnYield: true,
                   graphValues: FakeGraphValue.eth.values),
             .init(ticker: .from(json: "[\"tETHUSD\",10654,53.62425959,1065,76.68743116,745.1,-0.0152,10655,14420.34271146,10766,9889.1449809]"),
                   isEarnYield: false,
                   graphValues: [])]
        }
    }
    
    final class StubTickersListViewModel: TickersListViewModelProtocol {
        var state: PollingLoadingState = .idle
        var searchText: String = ""
        var toDisplay: [TickersListViewModel.TickerDataObject] = []
        func startPolling() {
            // Do nothing
        }
    }
}
#endif
