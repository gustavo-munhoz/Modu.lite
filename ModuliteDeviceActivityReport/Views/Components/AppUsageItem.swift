//
//  AppUsageItem.swift
//  ModuliteDeviceActivityReport
//
//  Created by Gustavo Munhoz Correa on 17/10/24.
//

import SwiftUI

struct AppUsageItem: View {
    var app: AppDeviceActivity
    var usagePercentage: Double

    var body: some View {
        HStack(spacing: 20) {
            if let token = app.token {
                Label(token)
                    .labelStyle(.iconOnly)
                    .scaleEffect(1.75)
            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text(app.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                 
                HStack(spacing: 16) {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: CGFloat(usagePercentage) * geometry.size.width)
                            .foregroundColor(.carrotOrange)
                    }
                    .frame(height: 12)
                    
                    Text(app.duration.formattedAsMinutes())
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
