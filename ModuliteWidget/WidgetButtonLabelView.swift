//
//  WidgetButtonLabelView.swift
//  ModuliteWidgetExtension
//
//  Created by André Wozniack on 27/08/24.
//

import SwiftUI

struct WidgetButtonLabelView: View {
    let buttons: [WidgetButtonView]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(0..<buttons.count, id: \.self) { index in
                        buttons[index]
                    }
                }
                
            }
            .padding(-8)
            .background(ignoresSafeAreaEdges: .all)
        }
    }
}

#Preview {
    WidgetButtonLabelView(buttons: Array(repeating: WidgetButtonView(image: .analogKnob, url: "modulite://"), count: 6))
}
