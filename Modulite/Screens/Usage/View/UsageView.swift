//
//  UsageView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/10/24.
//

import DeviceActivity
import SwiftUI

struct UsageView: View {
    
    @StateObject private var viewModel = UsageViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthorized {
                viewModel.createDeviceActivityReport()
                
            } else {
                NavigationStack {
                    EmptyView()
                }
                .navigationTitle("My screen time")
                .navigationBarTitleDisplayMode(.large)
                .background(.whiteTurnip)
            }
        }
        .onAppear {
            viewModel.performAuth()
        }
        .background(Color.whiteTurnip.ignoresSafeArea())
    }
}
