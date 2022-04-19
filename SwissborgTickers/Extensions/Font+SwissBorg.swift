//
//  Font+SwissBorg.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import SwiftUI

extension Font {
    static func ttCommons(weight: Font.Weight = .regular, size: CGFloat, relativeTo: TextStyle) -> Font {
        let baseName = "TTCommons"
        let weightName: String
        switch weight {
        case .regular:
            weightName = "Regular"
        case .semibold:
            weightName = "DemiBold"
        case .medium:
            weightName = "Medium"
        default:
            fatalError("Not supported")
        }
        
        let fontName = [baseName, weightName].joined(separator: "-")
        return Font.custom(fontName, size: size, relativeTo: relativeTo)
    }
}
