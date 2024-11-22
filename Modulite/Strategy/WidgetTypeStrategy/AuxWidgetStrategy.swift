//
//  AuxWidgetStrategy.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/11/24.
//

import Foundation
import WidgetStyling

class AuxWidgetStrategy: WidgetTypeStrategy {
    var type: WidgetType { .auxiliary }
    
    func getSetupStyleCollectionViewHeight() -> CGFloat {
        175
    }
    
    func getSetupStyleCellHeight() -> CGFloat {
        95
    }
    
    func getStyleCellImageHeight() -> CGFloat {
        86
    }
    
    func getEditorLayoutCollectionViewSize() -> CGSize {
        CGSize(width: 351, height: 164)
    }
    
    func getEditorModuleStyleItemSize() -> CGSize {
        CGSize(width: 108, height: 154)
    }
}
