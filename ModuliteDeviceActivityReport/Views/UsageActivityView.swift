//
//  UsageActivityView.swift
//  ModuliteDeviceActivityReport
//
//  Created by André Wozniack on 27/09/24.
//

import SwiftUI

struct UsageActivityView: View {
    var activityReport: ActivityReport
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    BorderedText(
                        text: Date.today.formattedWithOrdinal(),
                        maxWidth: 260
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
                
                Text(verbatim: .localized(for: .youHaveSpent))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.gray)
                
                BorderedText(
                    text: activityReport.formattedTime(for: .today),
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
                
                Separator()
                
                Text(verbatim: .localized(for: .comparisonOverview))
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding([.horizontal, .bottom], 24)
                
                HStack(alignment: .center) {
                    Spacer()
                    
                    LabeledBorderedText(
                        labelText: .localized(for: .screenTimeYesterday),
                        borderedText: activityReport.formattedTime(for: .yesterday),
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
                
                Separator()

                Text(verbatim: .localized(for: .howYouveSpentYourTime))
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .bottom], 24)
                
                AppUsageList(
                    apps: activityReport.relevantApps(for: .today)
                )
            }
            .background(.whiteTurnip)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
}
