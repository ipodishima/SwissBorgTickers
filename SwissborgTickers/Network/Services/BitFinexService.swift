//
//  BitFinexService.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import Foundation
import Moya

enum BitFinexService {
    case tickers(symbols: [TickersSymbols])
    
    enum TickersSymbols: String, CaseIterable {
        case tBTCUSD
        case tETHUSD
        case tCHSBUSD = "tCHSB:USD"
        case tLTCUSD
        case tXRPUSD
        case tDSHUSD
        case tRRTUSD
        case tEOSUSD
        case tSANUSD
        case tDATUSD
        case tSNTUSD
        case tDOGEUSD = "tDOGE:USD"
        case tLUNAUSD = "tLUNA:USD"
        case tMATICUSD = "tMATIC:USD"
        case tNEXOUSD = "tNEXO:USD"
        case tOCEANUSD = "tOCEAN:USD"
        case tBESTUSD = "tBEST:USD"
        case tAAVEUSD = "tAAVE:USD"
        case tPLUUSD
        case tFILUSD
    }
}

extension BitFinexService: TargetType {
    
    var baseURL: URL {
        AppSettings.currentBitFinexEnvironment.baseURL
    }
    
    var path: String {
        switch self {
        case .tickers:
            return "/tickers"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .tickers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .tickers(let symbols):
            let flattenedSymbols = symbols
                .map { $0.rawValue }
                .joined(separator: ",")
            return .requestParameters(parameters: ["symbols": flattenedSymbols],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
