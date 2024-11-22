//
//  WidgetModule+Extensions.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 07/11/24.
//

import UIKit
import WidgetStyling

extension WidgetModule {
    func createCompleteImage(for strategy: WidgetTypeStrategy) -> UIImage {
        let cell = WidgetModuleCell()
        cell.setup(
            with: self,
            cornerRadius: strategy.type == .main ? 12 : 18
        )
        cell.frame = CGRect(
            origin: .zero,
            size: strategy.getEditorModuleStyleItemSize()
        )
        
        cell.layoutIfNeeded()
        
        return cell.asImage()
    }
}

extension WidgetModule {
    convenience init?(persisted: PersistentWidgetModule) {
        let provider = try? WidgetStyleProvider()
        
        guard let moduleStyle = provider?.getModuleStyle(
            by: persisted.styleIdentifier
        ) else { return nil }
        
        self.init(
            style: moduleStyle,
            position: Int(persisted.position),
            appName: persisted.appName,
            urlScheme: persisted.urlScheme,
            color: persisted.selectedColor
        )
    }
}
