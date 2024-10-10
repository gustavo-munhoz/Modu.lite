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
                    HStack {
                        Group {
                            LazyVGrid(columns: columns, spacing: 4) {
                                ForEach(config.modules) { module in
                                    MainWidgetModuleButton(
                                        moduleImage: module.image,
                                        stringURL: module.associatedURLScheme?.absoluteString
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, -10)
                    .background(.black)
                    .background(ignoresSafeAreaEdges: .all)
                } else {
                    Image(.homeWidgetTutorialMain)
                        .resizable()
                        .scaledToFill()
                        .padding(.all, -16)
                }
            }
        }
    }
}
