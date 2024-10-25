//
//  LoadingView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/10/24.
//

import SwiftUI

struct LoadingView: View {
    var imageSize: CGSize = .init(width: 100, height: 100)
    var hasText: Bool = false
    
    @State private var currentImageIndex = 1
    private let totalImages = 8
    private let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Image("Loading\(currentImageIndex)")
                .resizable()
                .scaledToFit()
                .frame(width: imageSize.width, height: imageSize.height)

            if hasText {
                Text("Loading...")
                    .font(.headline)
                    .padding(.top, 10)
                    .foregroundStyle(.carrotOrange)
                    .pulseEffect()
                    
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentImageIndex = currentImageIndex % totalImages + 1
            }
        }
    }
}
