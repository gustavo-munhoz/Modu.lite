//
//  ConditionRowView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/10/24.
//

import SwiftUI

struct ConditionRowView<V: View>: View {
    var title: String
    var label: () -> V
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
            
            Spacer()
            
            label()
        }
    }
}
