//
//  Theme.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import SwiftUI

enum Theme {
    enum Font {
        static var titleBold: SwiftUI.Font {
            .ttCommons(weight: .semibold, size: 20.0, relativeTo: .title)
        }
        
        static var caption: SwiftUI.Font {
            .ttCommons(weight: .regular, size: 12.0, relativeTo: .caption)
        }
        
        static var body: SwiftUI.Font {
            .ttCommons(weight: .regular, size: 17.0, relativeTo: .body)
        }
    }
    
    enum Color {
        static var textOnColor: SwiftUI.Color {
            .init(white: 1)
        }
        
        static var lightGray: SwiftUI.Color {
            .init(white: 234/255)
        }
        
        static var black: SwiftUI.Color {
            .init(red: 16/255, green: 21/255, blue: 32/255)
        }
        
        static var positiveValue: SwiftUI.Color {
            .init(red: 27/255, green: 197/255, blue: 147/255)
        }
        
        static var error: SwiftUI.Color {
            .red
        }
        
        static var negativeValue: SwiftUI.Color {
            .red
        }
        
        static var orange: SwiftUI.Color {
            .init(red: 247/255, green: 149/255, blue: 28/255)
        }
        
        static var ethBlue: SwiftUI.Color {
            .init(red: 100/255, green: 129/255, blue: 234/255)
        }
        
        static var green: SwiftUI.Color {
            .init(red: 93/255, green: 204/255, blue: 156/255)
        }
        
        static var pink: SwiftUI.Color {
            .init(red: 193/255, green: 41/255, blue: 228/255)
        }
        
        static var purple: SwiftUI.Color {
            .init(red: 93/255, green: 67/255, blue: 245/255)
        }
        
        static var blue: SwiftUI.Color {
            .init(red: 68/255, green: 156/255, blue: 248/255)
        }
    }
}
