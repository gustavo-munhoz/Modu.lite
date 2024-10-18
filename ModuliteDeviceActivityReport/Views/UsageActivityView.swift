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
    
    @State private var transitionEdge: Edge = .leading
    
    private var isCurrentDateUseLessThanPrevious: Bool {
        activityReport.isPreviousDateUseLessThan(date: currentDate)
    }
    
    var activityReport: ActivityReport
    
    private var slideTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: transitionEdge),
            removal: .move(edge: transitionEdge.opposite)
        )
        .combined(with: .scale(scale: 0.25))
        .combined(with: .opacity)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    dateHeader
                    
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
            .background(Color.whiteTurnip.ignoresSafeArea())
            .navigationTitle("My screen time")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Subviews
    var dateHeader: some View {
        HStack {
            Button {
                guard canSubtractDay else { return }
                
                transitionEdge = .leading
                previousDate = currentDate
                withAnimation {
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
            .padding(.trailing, 16)
            .disabled(!canSubtractDay)
            
            BorderedText(
                text: currentDate.formattedWithOrdinal(),
                maxWidth: 260
            )
            
            Button {
                guard canAddDay else { return }
                
                transitionEdge = .trailing
                previousDate = currentDate
                withAnimation {
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
            .padding(.leading, 16)
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
            Text(
                verbatim: .localized(
                    for: currentDate == .today ? .youHaveSpent : .youSpent
                )
            )
            .font(.body.weight(.semibold))
            .foregroundStyle(.gray)
            .transition(slideTransition)
            .id("\(currentDate)-\(transitionEdge)")
            
            BorderedText(
                text: activityReport.formattedTime(for: currentDate),
                borderColor: isCurrentDateUseLessThanPrevious ? .fiestaGreen : .ketchupRed,
                textColor: .textPrimary,
                verticalPadding: 26,
                horizontalPadding: 32,
                font: .largeTitle.bold(),
                cornerRadius: 20,
                lineWidth: 4
            )
            .transition(slideTransition)
            .id("\(currentDate)-\(transitionEdge)")
            
            Text(
                verbatim: .localized(
                    for: currentDate == .today ?
                        .onYourPhoneToday : .onYourPhoneAt(
                            date: currentDate.formattedWithDayAndMonth()
                        )
                )
            )
            .transition(slideTransition)
            .id("\(currentDate)-\(transitionEdge)")
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
                    labelText: .localized(
                        for: currentDate == .today ?
                            .screenTimeYesterday : .screenTimeDayBefore
                    ),
                    borderedText: activityReport.formattedTime(
                        for: currentDate.subtractOneDay()
                    ),
                    borderColor: .carrotOrange
                )
                .transition(.blurReplace)
                .id(currentDate)
                .padding(.trailing, -12)
                
                LabeledBorderedText(
                    labelText: .localized(for: .screenTime7DaysAverage),
                    labelWidth: 125,
                    borderedText: activityReport.formattedAverageTimeLastWeek,
                    borderColor: .carrotOrange
                )
                .transition(.blurReplace)
                .id(currentDate)
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

extension Edge {
    var opposite: Edge {
        switch self {
        case .leading:
            return .trailing
        case .trailing:
            return .leading
        case .top:
            return .bottom
        case .bottom:
            return .top
        }
    }
}
