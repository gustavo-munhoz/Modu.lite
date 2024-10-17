//
//  UsageActivityView.swift
//  ModuliteDeviceActivityReport
//
//  Created by André Wozniack on 27/09/24.
//

import SwiftUI

struct UsageActivityView: View {
    // MARK: - Properties
    
    @State var currentDate: Date = .today {
        didSet {
            canAddDay = currentDate < .today
            canSubtractDay = currentDate > .today.subtractingDays(7)
        }
    }
    @State var previousDate: Date = .today
    @State private var animateLeft = false
    @State private var animateRight = false
    
    @State private var canAddDay: Bool = false
    @State private var canSubtractDay: Bool = true
    
    var activityReport: ActivityReport
    
    // MARK: - Body
    var body: some View {
        VStack {
            dateHeader
            
            ScrollView {
                VStack {
                    mainScreenTimeLabel
                    
                    Separator()
                    
                    comparisonOverview
                    
                    Separator()
                    
                    appUsageList
                }
                .background(.whiteTurnip)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
        }
    }
    
    // MARK: - Subviews
    var dateHeader: some View {
        HStack {
            Button {
                guard canSubtractDay else { return }
                
                withAnimation {
                    previousDate = currentDate
                    currentDate = currentDate.subtractOneDay()
                    animateLeft = true
                    animateRight = false
                }
            } label: {
                Image(systemName: "arrow.left.circle")
                    .font(.title.weight(.semibold))
                    .foregroundStyle(canSubtractDay ? .carrotOrange : .gray)
                    .symbolEffect(.bounce, options: .speed(2), value: animateLeft)
            }
            .disabled(!canSubtractDay)
            
            BorderedText(
                text: currentDate.formattedWithOrdinal(),
                maxWidth: 260
            )
            
            Button {
                guard canAddDay else { return }
                
                withAnimation {
                    previousDate = currentDate
                    currentDate = currentDate.addOneDay()
                    animateRight = true
                    animateLeft = false
                }
            } label: {
                Image(systemName: "arrow.right.circle")
                    .font(.title.weight(.semibold))
                    .foregroundStyle(canAddDay ? .carrotOrange : .gray)
                    .symbolEffect(.bounce, options: .speed(2), value: animateRight)
            }
            .disabled(!canAddDay)
        }
        .onChange(of: currentDate) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                animateLeft = false
                animateRight = false
            }
        }
        .padding(24)
    }
    
    var mainScreenTimeLabel: some View {
        VStack {
            Text(verbatim: .localized(for: .youHaveSpent))
                .font(.body.weight(.semibold))
                .foregroundStyle(.gray)
            
            BorderedText(
                text: activityReport.formattedTime(for: currentDate),
                textColor: .textPrimary,
                verticalPadding: 26,
                horizontalPadding: 32,
                font: .largeTitle.bold(),
                cornerRadius: 20,
                lineWidth: 4
            )
            
            Text(verbatim: .localized(for: .onYourPhoneToday))
                .font(.body.weight(.semibold))
                .foregroundStyle(.gray)
        }
    }
    
    var comparisonOverview: some View {
        VStack {
            Text(verbatim: .localized(for: .comparisonOverview))
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding([.horizontal, .bottom], 24)
            
            HStack(alignment: .center) {
                Spacer()
                
                LabeledBorderedText(
                    labelText: .localized(for: .screenTimeYesterday),
                    borderedText: activityReport.formattedTime(
                        for: currentDate.subtractOneDay()
                    ),
                    borderColor: .ketchupRed
                )
                .padding(.trailing, -12)
                
                LabeledBorderedText(
                    labelText: .localized(for: .screenTime7DaysAverage),
                    labelWidth: 125,
                    borderedText: activityReport.formattedAverageTimeLastWeek,
                    borderColor: .fiestaGreen
                )
                .padding(.leading, -12)
                
                Spacer()
            }
        }
    }
    
    var appUsageList: some View {
        VStack {
            Text(verbatim: .localized(for: .howYouveSpentYourTime))
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .bottom], 24)
            
            AppUsageList(
                apps: activityReport.relevantApps(for: currentDate)
            )
        }
    }
}
