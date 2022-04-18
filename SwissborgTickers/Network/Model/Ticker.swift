//
//  Ticker.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import Foundation

struct Ticker: Decodable {
    /// The symbol of the requested ticker data
    let symbol: BitFinexService.TickerSymbol
    
    /// Price of last highest bid
    let bid: Float
    
    /// Sum of the 25 highest bid sizes
    let bidSize: Float
    
    /// Price of last lowest ask
    let ask: Float
    
    /// Sum of the 25 lowest ask sizes
    let askSize: Float
    
    /// Amount that the last price has changed since yesterday
    let dailyChange: Float
    
    /// Relative price change since yesterday (*100 for percentage change)
    let dailyChangeRelative: Float

    /// Price of the last trade
    let lastPrice: Float
    
    /// Daily volume
    let volume: Float
    
    /// Daily high
    let high: Float
    
    /// Daily low
    let low: Float
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        symbol = try container.decode(BitFinexService.TickerSymbol.self)
        bid = try container.decode(Float.self)
        bidSize = try container.decode(Float.self)
        ask = try container.decode(Float.self)
        askSize = try container.decode(Float.self)
        dailyChange = try container.decode(Float.self)
        dailyChangeRelative = try container.decode(Float.self)
        lastPrice = try container.decode(Float.self)
        volume = try container.decode(Float.self)
        high = try container.decode(Float.self)
        low = try container.decode(Float.self)
    }
}
