//
//  MainWidgetStrategy.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/11/24.
//

import Foundation
import WidgetStyling

class MainWidgetStrategy: WidgetTypeStrategy {
    var type: WidgetType { .main }
    
    func getSetupStyleCollectionViewHeight() -> CGFloat {
        270
    }
    
    func getSetupStyleCellHeight() -> CGFloat {
        196
    }
    
    func getStyleCellImageHeight() -> CGFloat {
        187
    }
    
    func getEditorLayoutCollectionViewHeight() -> CGFloat {
        0
    }
}
