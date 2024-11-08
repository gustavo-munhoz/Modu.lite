//
//  WidgetType.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import Foundation

public enum WidgetType: String {
    case main
    case auxiliary
    
    var maxModules: Int {
        switch self {
        case .main:
            return 6
        case .auxiliary:
            return 3
        }
    }
}
