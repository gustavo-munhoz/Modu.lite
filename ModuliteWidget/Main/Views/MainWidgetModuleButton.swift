//
//  MainWidgetModuleButton.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 24/09/24.
//

import SwiftUI

struct MainWidgetModuleButton: View {
    var moduleImage: Image
    var stringURL: String?
    
    var body: some View {
        Group {
            if let stringURL = stringURL {
                Link(destination: URL(string: "moduliteap://app?app=\(stringURL)")!) {
                    moduleImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
            } else {
                moduleImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
