//
//  ComingSoonFeature.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 10/10/24.
//

import UIKit

enum ComingSoonFeature {
    case screenTime
    case appBlocking
    
    var iconName: String {
        switch self {
        case .appBlocking: return "lock.fill"
        case .screenTime: return "chart.bar.xaxis"
        }
    }
    
    var color: UIColor {
        switch self {
        case .screenTime: return .carrotOrange
        case .appBlocking: return .ketchupRed
        }
    }
    
    var titleKey: ComingSoonLocalizedTexts {
        switch self {
        case .screenTime: return .comingSoonViewScreenTimeTitle
        case .appBlocking: return .comingSoonViewAppBlockingTitle
        }
    }
    
    var descriptionKey: ComingSoonLocalizedTexts {
        switch self {
        case .screenTime: return .comingSoonViewScreenTimeDescription
        case .appBlocking: return .comingSoonViewAppBlockingDescription
        }
    }
}
