//
//  PollingLoadingState.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import Foundation

enum PollingLoadingState {
    case idle
    case loading
    case refreshing
    case failed(Error, context: LoadingContext)
    case loaded
    
    enum LoadingContext {
        case initial
        case refresh
    }
    
    var initialLoadingError: Error? {
        switch self {
        case let .failed(error, context) where context == .initial:
            return error
        default:
            return nil
        }
    }
    
    var pollingError: Error? {
        switch self {
        case let .failed(error, context) where context == .refresh:
            return error
        default:
            return nil
        }
    }
    
    var isRefreshing: Bool {
        switch self {
        case .refreshing:
            return true
        default:
            return false
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
}
