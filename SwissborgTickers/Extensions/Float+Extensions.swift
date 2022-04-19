//
//  Float+Extensions.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import Foundation
import SwiftUI

extension Float {
    
    /// Returns the value formatted as percent using the user locale with + or - sign as prefix
    var asPercentageWithExplicitSign: String {
        // There must be a better way
        var formattedValue = self.formatted(.percent)
        if self < 0 {
            formattedValue = formattedValue.prefixIfNeeded(with: "-")
        } else if self > 0 {
            formattedValue = formattedValue.prefixIfNeeded(with: "+")
        }
        
        return formattedValue
    }
}
