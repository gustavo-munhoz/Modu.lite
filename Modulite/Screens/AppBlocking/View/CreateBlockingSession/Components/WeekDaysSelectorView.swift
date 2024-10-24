//
//  WeekDaysSelectorView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 23/10/24.
//

import SwiftUI

struct WeekDaysSelectorView: View {
    @Binding var selectedDays: [SelectableDay]
    
    private var selectedCount: Int {
        selectedDays.filter { $0.isSelected }.count
    }
    
    var body: some View {
        VStack {
            ConditionRowView(title: "Days of the week") {
                Text("\(selectedCount)/7 days")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            }
            
            HStack {
                ForEach(selectedDays.indices, id: \.self) { index in
                    WeekDayButton(day: selectedDays[index])
                }
            }
        }
    }
}

struct WeekDayButton: View {
    @State var day: SelectableDay
    
    var body: some View {
        Button(action: {
            day.isSelected.toggle()
        }, label: {
            Text(day.day.localizedFirstLetter)
                .font(.title2.bold())
                .foregroundColor(day.isSelected ? .white : .black)
                .frame(width: 43, height: 43)
                .background(day.isSelected ? Color.carrotOrange : Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.carrotOrange, lineWidth: 2)
                )
        })
    }
}
