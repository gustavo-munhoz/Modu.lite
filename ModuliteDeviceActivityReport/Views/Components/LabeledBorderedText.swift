//
//  LabeledBorderedText.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 16/10/24.
//

import SwiftUI

struct LabeledBorderedText: View {
    var labelText: String = ""
    var labelTextColor: Color = .gray
    var labelFont: Font = .callout.weight(.semibold)
    var labelWidth: CGFloat? = 140
    
    var borderedText: String = ""
    var borderedTextColor: Color = .textPrimary
    var borderColor: Color = .gray
    var borderedFont: Font = .body.bold()
    var borderedTextWidth: CGFloat? = 125
    var cornerRadius: CGFloat = 20
    var borderWidth: CGFloat = 3
    
    var maxWidth: CGFloat? = .infinity
    var borderedTextVerticalPadding: CGFloat = 12
    
    var body: some View {
        VStack {
            Text(labelText)
                .font(labelFont)
                .foregroundColor(labelTextColor)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: labelWidth)
                        
            BorderedText(
                text: borderedText,
                borderColor: borderColor,
                textColor: borderedTextColor,
                maxWidth: maxWidth,
                verticalPadding: borderedTextVerticalPadding,
                font: borderedFont,
                cornerRadius: cornerRadius,
                lineWidth: borderWidth
            )
            .frame(width: borderedTextWidth)
        }
        .frame(maxWidth: maxWidth)
    }
}
