//
//  BitFinexService.TickerSymbol+UI.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import Foundation
import UIKit
import SwiftUI

extension BitFinexService.TickerSymbol {
    
    var icon: UIImage {
        let image: UIImage?
        switch self {
        case .tBTCUSD:
            image = UIImage(named: "ic_crypto_btc_Normal")
        case .tETHUSD:
            image = UIImage(named: "ic_crypto_eth_Normal")
        default:
            image = background.icon.add(text: symbol)
        }
        
        guard let image = image else {
            assertionFailure("Cannot generate an image")
            return UIImage()
        }
        return image
    }
    
    var backgroundColor: Color {
        let color: Color
        switch self {
        case .tBTCUSD:
            color = Theme.Color.orange
        case .tETHUSD:
            color = Theme.Color.ethBlue
        default:
            color = background.color
        }
        
        return color
    }
    
    private var background: Background {
        let symbolIndex = BitFinexService.TickerSymbol.allCases.firstIndex(of: self) ?? 0
        let backgrounds = Background.allCases
        return backgrounds[symbolIndex % backgrounds.count]
    }
    
    enum Background: String, CaseIterable {
        case action
        case alert
        case information
        case notification
        case special
        
        var icon: UIImage {
            UIImage(named: "ic_shape_\(rawValue)_Normal") ?? UIImage()
        }
        
        var color: Color {
            let color: Color
            switch self {
            case .action:
                color = Theme.Color.green
            case .alert:
                color = Theme.Color.orange
            case .information:
                color = Theme.Color.blue
            case .notification:
                color = Theme.Color.purple
            case .special:
                color = Theme.Color.pink
            }
            
            return color
        }
    }

}
