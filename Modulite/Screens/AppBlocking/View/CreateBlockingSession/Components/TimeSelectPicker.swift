//
//  TimeSelectPicker.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/10/24.
//

import SwiftUI

struct TimeSelectPicker: View {
    var date: Binding<Date>
    
    var body: some View {
        VStack {
            Text(date.wrappedValue.formatted(.dateTime.hour().minute()))
                .fontWeight(.semibold)
                .foregroundStyle(.figBlue)
        }
        .frame(minWidth: 55)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.potatoYellow)
                .opacity(0.75)
        )
        .overlay {
            DatePicker(
                "",
                selection: date,
                displayedComponents: .hourAndMinute
            )
            .colorMultiply(.clear)
            .datePickerStyle(DefaultDatePickerStyle())
            .labelsHidden()
        }
    }
}
