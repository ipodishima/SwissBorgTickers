//
//  SwissborgTickersApp.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import SwiftUI

@main
struct SwissborgTickersApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TickersList(viewModel: TickersListViewModel())
            }
            // Full screen on iPad
            .navigationViewStyle(.stack)
        }
    }
}
