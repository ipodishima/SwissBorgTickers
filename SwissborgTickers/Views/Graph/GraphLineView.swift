//
//  GraphLineView.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import SwiftUI

// Note: It seems that performances are not great, but it was a bit expected given the naive approach :D
struct GraphLineView: View {
    let dataPoints: [Double]
    let color: Color
    
    var body: some View {
        GraphShape(dataPoints: dataPoints, isClosed: false)
            .stroke(color, style: StrokeStyle(lineWidth: 1, lineJoin: .round))
            .overlay(GraphShape(dataPoints: dataPoints, isClosed: true)
                        .fill(gradient))
            .padding(.vertical)
    }
    
    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [color.opacity(0.8), color.opacity(0.0)]),
                       startPoint: .top,
                       endPoint: .bottom)
    }
    
    struct GraphShape: Shape {
        let dataPoints: [Double]
        let isClosed: Bool
        
        func path(in rect: CGRect) -> Path {
            let height = rect.height
            let width = rect.width
            
            return Path { path in
                path.move(to: CGPoint(x: 0, y: yPosition(index: 0, height: height)))
                
                for index in 1..<dataPoints.count {
                    path.addLine(to: CGPoint(x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                                             y: yPosition(index: index, height: height)))
                }
                
                if isClosed {
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                    path.addLine(to: CGPoint(x: 0, y: yPosition(index: 0, height: height)))
                }
            }
        }
        
        private func yPosition(index: Int, height: CGFloat) -> CGFloat {
            height * (1 - ratio(for: index))
        }
        
        private var highestPoint: Double {
            max(dataPoints.max() ?? 1.0, 1.0)
        }
        
        private var minPoint: Double {
            dataPoints.min() ?? 1.0
        }
        
        private func ratio(for index: Int) -> Double {
            (dataPoints[index] - minPoint) / (highestPoint - minPoint)
        }
    }
}

#if DEBUG
struct GraphLineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GraphLineView(dataPoints: [10, 20, 10, 30, 40, 10, 12, 13, 0, 40, 1],
                          color: .blue)
            GraphLineView(dataPoints: FakeGraphValue.eth.values,
                          color: .red)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
#endif
