//
//  AppBlockingViewModel.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import Foundation

class AppBlockingViewModel: ObservableObject {
    
    @Published var sessions: [AppBlockingSession] = []
    
}
