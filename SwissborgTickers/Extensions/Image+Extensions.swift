//
//  Image+Extensions.swift
//  SwissborgTickers
//
//  Created by Marian Paul on 2022-04-18.
//

import Foundation
import UIKit
import SwiftUI

extension UIImage {
    
    /// Add some text inside the image (centered)
    /// - Parameters:
    ///   - text: The text to add
    ///   - textColor: The text color. Default is white
    ///   - font: The font. Default is system font (8, regular)
    /// - Returns: The image with a text overlay
    func add(text: String,
             color textColor: UIColor = .white,
             font: UIFont = .systemFont(ofSize: 8, weight: .regular)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        draw(in: CGRect(origin: .zero, size: size))
        
        var textFontAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: style
        ]
        
        let textSize = text.size(withAttributes: textFontAttributes)
        let ratio = size.width / textSize.width * 0.7
        
        let textHeight = textSize.height
        let textYPosition = (size.height - textHeight * ratio) / 2
        
        let finalFont = font.withSize(font.pointSize * ratio)
        textFontAttributes[.font] = finalFont
        
        let textRect = CGRect(x: 0, y: textYPosition, width: size.width, height: textHeight)
        text.draw(in: textRect.integral, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? UIImage()
    }
    
}

#if DEBUG
struct UIImageExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Image(uiImage: UIImage(named: "ic_shape_action_Normal")?.add(text: "BTC") ?? UIImage())
            Image(uiImage: UIImage(named: "ic_shape_action_Normal")?.add(text: "CHSB") ?? UIImage())
            Image(uiImage: UIImage(named: "ic_shape_action_Normal")?.add(text: "BLABLA") ?? UIImage())
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
