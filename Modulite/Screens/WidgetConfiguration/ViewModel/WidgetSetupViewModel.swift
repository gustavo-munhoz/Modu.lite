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
    
    @Published var apps: [String] = [
        "Whats App",
        "Instagram",
        "Facebook",
        "PicPay",
        "Snapchat",
        "Woofy"
    ]
    
    @Published var selectedApps: [String] = []
}
