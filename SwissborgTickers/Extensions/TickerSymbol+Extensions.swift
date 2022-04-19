//
//  TickerSymbol+Extensions.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import Foundation

extension BitFinexService.TickerSymbol {
    
    var name: String {
        // We should translate that and it probably would come from the API
        [symbol, "coin"].joined(separator: " ")
    }
    
    var symbol: String {
        var rawName = rawValue
        // Remove the t
        _ = rawName.removeFirst()
        // Remove USD
        var withoutUSD = rawName.replacingOccurrences(of: "USD", with: "")
        if withoutUSD.hasSuffix(":") {
            _ = withoutUSD.removeLast()
        }
        return withoutUSD
    }
    
    var currencyCode: String {
        return "USD"
    }
    
}
