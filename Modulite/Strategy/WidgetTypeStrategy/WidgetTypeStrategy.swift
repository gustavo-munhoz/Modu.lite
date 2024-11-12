//
//  WidgetTypeStrategy.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/11/24.
//

import Foundation

protocol WidgetTypeStrategy: AnyObject {
    func getSetupStyleCollectionViewHeight() -> CGFloat
    func getSetupStyleCellHeight() -> CGFloat
    func getEditorLayoutCollectionViewHeight() -> CGFloat    
}
