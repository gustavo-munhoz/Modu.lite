//
//  WidgetButtonView.swift
//  ModuliteWidgetExtension
//
//  Created by André Wozniack on 27/08/24.
//

import SwiftUI

struct WidgetButtonView: View {
    var image: UIImage
    var url: String
    
    var body: some View {
        
        Link(destination: URL(string: "moduliteapp://app?app=\(url)")!) {
            Image(uiImage: image)
        }
    }
}

#Preview {
    WidgetButtonView(image: .analogKnob, url: "googlemaps://")
}
