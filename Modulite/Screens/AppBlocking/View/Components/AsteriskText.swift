//
//  AsteriskText.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/10/24.
//

import SwiftUI

struct AsteriskText: View {
    var text: String = ""
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(systemName: "asterisk")
                .resizable()
                .fontWeight(.heavy)
                .aspectRatio(contentMode: .fit)
                .frame(width: 21, height: 21)
                .foregroundColor(.lemonYellow)
                        
            Text(text)
                .font(.system(.title2, design: .default).bold().italic())
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
                .padding(.leading, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
