//
//  Separator.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 16/10/24.
//

import SwiftUI

struct Separator: View {
    var verticalPadding: CGFloat = 24
    var horizontalPadding: CGFloat = 24
    
    var body: some View {
        Rectangle()
            .fill(.potatoYellow)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
    }
}
