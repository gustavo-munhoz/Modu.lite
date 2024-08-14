//
//  HomeViewModel.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import Combine

class HomeViewModel: NSObject {
    @Published var mainWidgets: [UIImage] = [
        UIImage(systemName: "gear")!,
        UIImage(systemName: "gear")!,
        UIImage(systemName: "gear")!
    ]
    @Published var auxiliaryWidgets: [UIImage] = [
        UIImage(systemName: "trash.fill")!,
        UIImage(systemName: "trash.fill")!,
    ]
    @Published var tips: [UIImage] = []
}
