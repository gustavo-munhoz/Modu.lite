//
//  WidgetSetupViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 15/08/24.
//

import UIKit
import Combine

class WidgetSetupViewModel: NSObject {
    @Published var widgetStyles: [UIImage] = [
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!,
        UIImage(systemName: "house.fill")!
    ]
    
    private var allApps: [String] = [
        "Whats App",
        "Instagram",
        "Facebook",
        "PicPay",
        "Snapchat",
        "Woofy"
    ]
    
    @Published var apps: [String]
    
    @Published var selectedApps: [String] = []
    
    override init() {
        self.apps = allApps
    }
    
    func filterApps(for query: String) {
        guard !query.isEmpty else {
            apps = allApps
            return
        }
        apps = allApps.filter { $0.lowercased().contains(query.lowercased())}
    }
}
