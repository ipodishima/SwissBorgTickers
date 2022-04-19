//
//  TickerView.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-17.
//

import SwiftUI

struct TickerView: View {
    let ticker: Ticker
    let isEarnYield: Bool
    let graphValues: [Double]
    
    var body: some View {
        VStack {
            HStack(spacing: Constants.graphYSpacing) {
                Image(uiImage: ticker.symbol.icon)
                    .resizable()
                    .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
                VStack(alignment: .leading, spacing: Constants.titleSubtitleYSpacing) {
                    Text(ticker.symbol.name)
                        .font(Theme.Font.titleBold)
                        .foregroundColor(Theme.Color.black)
                        .lineLimit(1)
                    HStack {
                        if isEarnYield {
                            // Should be translated as well
                            Text("EARN YIELD")
                                .foregroundColor(Theme.Color.textOnColor)
                                .font(Theme.Font.caption)
                                .padding(Constants.earnYieldCapsulePadding)
                                .background(ticker.symbol.backgroundColor)
                                .cornerRadius(Constants.earnYieldCapsuleCornerRadius)
                                .lineLimit(1)
                        }
                        Text(ticker.symbol.symbol)
                            .font(Theme.Font.body)
                            .foregroundColor(Theme.Color.black)
                            .lineLimit(1)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                .fixedSize(horizontal: true, vertical: false)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(ticker.lastPrice.formatted(.currency(code: ticker.symbol.currencyCode)))
                        .transition(AnyTransition.opacity.combined(with: .scale))
                        .font(Theme.Font.titleBold)
                    Text(ticker.dailyChangeRelative.asPercentageWithExplicitSign)
                        .font(Theme.Font.body)
                        .foregroundColor(ticker.dailyChangeRelative < 0 ? Theme.Color.negativeValue : Theme.Color.positiveValue)
                }
                .fixedSize(horizontal: true, vertical: false)
            }
            .padding(Constants.contentPadding)

            if !graphValues.isEmpty {
                GraphLineView(dataPoints: graphValues,
                              color: ticker.symbol.backgroundColor)
                    .frame(height: Constants.graphHeight)
            }
        }
        .background(Color.white)
        .cornerRadius(Constants.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Theme.Color.lightGray, style: StrokeStyle(lineWidth: Constants.borderWidth))
        )
        .shadow(color: .init(white: 0.8), radius: Constants.shadowRadius, x: 0, y: Constants.shadowRadius)
    }
    
    private enum Constants {
        static let graphYSpacing: CGFloat = 12
        static let iconSize = CGSize(width: 45, height: 45)
        static let titleSubtitleYSpacing: CGFloat = 0
        static let earnYieldCapsulePadding = EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6)
        static let earnYieldCapsuleCornerRadius: CGFloat = 4
        static let contentPadding = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let graphHeight: CGFloat = 100
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 6
        static let shadowRadius: CGFloat = 5
    }
}

#if DEBUG
struct TickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TickerView(ticker: DataSet.btcUSD, isEarnYield: true, graphValues: [])
            TickerView(ticker: DataSet.btcUSD, isEarnYield: false, graphValues: [])
            TickerView(ticker: DataSet.btcUSD, isEarnYield: false, graphValues: FakeGraphValue.eth.values)
            TickerView(ticker: DataSet.ethUSD, isEarnYield: true, graphValues: [])
            TickerView(ticker: DataSet.ltcUSD, isEarnYield: true, graphValues: [])
        }
        .padding(.all, 10)
        .previewLayout(.sizeThatFits)
    }
    
    private enum DataSet {
        static var btcUSD: Ticker {
            .from(json: "[\"tBTCUSD\",10654,53.62425959,10655,76.68743116,745.1,0.0752,10655,14420.34271146,10766,9889.1449809]")
        }
        
        static var ethUSD: Ticker {
            .from(json: "[\"tETHUSD\",10654,53.62425959,10655,76.68743116,745.1,0.0752,10655,14420.34271146,10766,9889.1449809]")
        }
        
        static var ltcUSD: Ticker {
            .from(json: "[\"tLTCUSD\",10654,53.62425959,14.76,76.68743116,745.1,-0.0752,10655,14420.34271146,10766,9889.1449809]")
        }
    }
}

extension Ticker {
    static func from(json: String) -> Ticker {
        let data = json.data(using: .utf8)!
        return (try? JSONDecoder().decode(Ticker.self, from: data))!
    }
}
#endif
