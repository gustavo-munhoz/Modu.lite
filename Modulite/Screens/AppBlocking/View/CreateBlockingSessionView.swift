//
//  CreateBlockingSessionView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 22/10/24.
//

import SwiftUI
import FamilyControls

struct CreateBlockingSessionView: View {
    
    @StateObject var builder = AppBlockingSessionBuilder()
    @State private var isPresentingScreenTimeSelector = false
    @FocusState private var isTextFielFocused: Bool
    
    var onSavePressed: ((AppBlockingSession) -> Void)?
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                TextField(
                    String.localized(for: .createBlockingSessionName),
                    text: $builder.sessionName
                )
                    .font(.title2.bold())
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(.potatoYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .focused($isTextFielFocused)
                
                Button(action: {
                    isTextFielFocused = true
                }, label: {
                    Image(systemName: "square.and.pencil")
                    .foregroundStyle(.figBlue)
                    .font(.title)
                    .fontWeight(.bold)
                })
            }
            .padding(.bottom)
            
            HStack {
                AsteriskText(text: .localized(for: .createBlockingSessionChooseApps))
                
                Text(
                    String.localized(
                        for: .createBlockingSessionSelectedCount(number: builder.selectedCount)
                    )
                )
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.lemonYellow, lineWidth: 2)
                }
            }
            
            Button(action: {
                isPresentingScreenTimeSelector = true
            }, label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        
                    Text(String.localized(for: .createBlockingSessionSearchApps))
                    .fontWeight(.bold)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
                .font(.title2)
                .foregroundStyle(.white)
                .background(.carrotOrange)
            })
            .sheet(isPresented: $isPresentingScreenTimeSelector) {
                ScreenTimeSelectAppsContentView(
                    session: builder.getSession(),
                    onComplete: { selection in
                        builder.setActivitySelection(selection)
                        isPresentingScreenTimeSelector = false
                    },
                    onCancel: { isPresentingScreenTimeSelector = false }
                )
            }
            
            AsteriskText(text: .localized(for: .createBlockingSessionSelectConditions))
            
            HStack {
                BlockingTypeSelectButton(
                    title: .localized(for: .createBlockingSessionScheduled),
                    isSelected: Binding(
                        get: { builder.blockingType == .scheduled },
                        set: { newValue in
                            if newValue {
                                builder.blockingType = .scheduled
                            }
                        }
                    )
                )
                
                BlockingTypeSelectButton(
                    title: .localized(for: .createBlockingSessionAlwaysOn),
                    isSelected: Binding(
                        get: { builder.blockingType == .alwaysOn },
                        set: { newValue in
                            if newValue {
                                builder.blockingType = .alwaysOn
                            }
                        }
                    )
                )
            }
            
            Group {
                if builder.blockingType == .scheduled {
                    VStack {
                        ConditionRowView(
                            title: .localized(for: .createBlockingSessionAllDay)
                        ) {
                            Toggle(isOn: $builder.isAllDay, label: {})
                                .tint(.fiestaGreen)
                        }

                        if !builder.isAllDay {
                            ConditionRowView(
                                title: .localized(for: .createBlockingSessionStartAt)
                            ) {
                                TimeSelectPicker(date: $builder.startTime)
                            }
                            .transition(.opacity)

                            ConditionRowView(
                                title: .localized(for: .createBlockingSessionFinishesAt)
                            ) {
                                TimeSelectPicker(date: $builder.finishTime)
                            }
                            .transition(.opacity)
                        }

                        WeekDaysSelectorView(selectedDays: $builder.selectedDays)
                            .background(.whiteTurnip)
                    }
                    .animation(.easeInOut, value: builder.isAllDay)
                }
            }
            
            Button(action: {
                let session = builder.build()
                onSavePressed?(session)
            }, label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    
                    Text(String.localized(for: .createBlockingSessionSaveSession))
                }
                .foregroundStyle(.white)
                .font(.title2.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.fiestaGreen)
            })
            
            Spacer()
        }
        .padding(24)
        .background(.whiteTurnip)
    }
}

class AppBlockingSessionBuilder: ObservableObject {
    // MARK: - Properties
    private var session = AppBlockingSession()
    
    @Published var sessionName: String = ""
    @Published var blockingType: BlockingType = .scheduled
    @Published var isAllDay: Bool = false
    @Published var startTime: Date = .now
    @Published var finishTime: Date = Calendar.current.startOfDay(for: .now)
    @Published var selectedDays: [SelectableDay] = .allWithState(false)
    
    var selectedCount: Int {
        session.totalSelectionCount
    }
    
    // MARK: - Build
    func build() -> AppBlockingSession {
        session.sessionName = sessionName
        session.blockingType = blockingType
        session.isAllDay = isAllDay
        
        // FIXME: Implement this
//        session.startsAt = startTime
//        session.endsAt = finishTime
//        session.daysOfWeek = selectedDays
        
        return session
    }
    
    // MARK: - Setters
    func setActivitySelection(_ selection: FamilyActivitySelection) {
        session.activitySelection = selection
    }
    
    // MARK: - Getters
    func getSession() -> AppBlockingSession {
        session
    }
}

#Preview {
    CreateBlockingSessionView()
}
