//
//  BorderedText.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 16/10/24.
//

import SwiftUI

struct BorderedText: View {
    var text: String = ""
    var borderColor: Color = .carrotOrange
    var textColor: Color = .carrotOrange
    var maxWidth: CGFloat?
    var verticalPadding: CGFloat = 6
    var horizontalPadding: CGFloat = 12
    var font: Font = .title3.bold()
    var cornerRadius: CGFloat = 10
    var lineWidth: CGFloat = 3

    var body: some View {
        Text(text)
            .frame(maxWidth: maxWidth)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .font(font)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth))
                    .fill(borderColor)
            )
    }
}
