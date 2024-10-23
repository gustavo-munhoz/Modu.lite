//
//  BlockingTypeSelectButton.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/10/24.
//

import SwiftUI

struct BlockingTypeSelectButton: View {
    var title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: {
            isSelected = true
        }, label: {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(isSelected ? .white : .black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.carrotOrange : Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.carrotOrange, lineWidth: 2)
                )
        })
    }
}
