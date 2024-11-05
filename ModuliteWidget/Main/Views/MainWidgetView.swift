//
//  MainWidgetView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import SwiftUI
import WidgetKit

struct MainWidgetView: View {
    var entry: MainWidgetProvider.Entry
    
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
                                    MainWidgetModuleButton(
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
                    Image(.homeWidgetTutorialMain)
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

extension View {
    @ViewBuilder
    func backgroundView(for background: WidgetBackground) -> some View {
        switch background {
        case .image(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
            
        case .color(let uiColor):
            Color(uiColor)
        }
    }
    
    @ViewBuilder
    func widgetBackground<T: View>(@ViewBuilder content: () -> T) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget, content: content)
        } else {
            background(content())
        }
    }
}
