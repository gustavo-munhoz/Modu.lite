//
//  WidgetTypeStrategy.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/11/24.
//

import Foundation
import WidgetStyling

protocol WidgetTypeStrategy: AnyObject {
    var type: WidgetType { get }
    func getSetupStyleCollectionViewHeight() -> CGFloat
    func getSetupStyleCellHeight() -> CGFloat
    func getStyleCellImageHeight() -> CGFloat
    func getEditorLayoutCollectionViewSize() -> CGSize
    func getEditorModuleStyleItemSize() -> CGSize
}
