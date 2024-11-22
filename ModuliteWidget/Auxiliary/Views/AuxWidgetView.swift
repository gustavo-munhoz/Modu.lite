//
//  AuxWidgetView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import SwiftUI
import WidgetKit
import WidgetStyling

struct AuxWidgetView: View {
    var entry: AuxWidgetIntentProvider.Entry
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Group {
                if let config = entry.configuration {
                    let background = config.background
                    
                    HStack {
                        Group {
                            LazyVGrid(columns: columns, spacing: 2) {
                                ForEach(config.modules) { module in
                                    WidgetModuleButton(
                                        moduleImage: module.image,
                                        stringURL: module.associatedURLScheme?.absoluteString
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 6)
                    .edgesIgnoringSafeArea(.all)
                    .widgetBackground {
                        backgroundView(for: background)
                    }
                    
                } else {
                    Image("homeWidgetTutorialAux")
                        .resizable()
                        .scaledToFill()
                        .padding(.all, -16)
                        .widgetBackground {
                            Color.clear
                        }
                }
            }
        }
    }
}
