//
//  WidgetSetupViewControllerDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import UIKit
import WidgetStyling

protocol WidgetSetupViewControllerDelegate: AnyObject {
    func getPlaceholderName() -> String
    
    func widgetSetupViewControllerDidPressNext(widgetName: String)
    
    func widgetSetupViewControllerDidTapSearchApps(
        _ parentController: WidgetSetupViewController
    )
    
    func widgetSetupViewControllerDidDeselectApp(
        _ controller: WidgetSetupViewController,
        app: AppData
    )
    
    func widgetSetupViewControllerDidSelectWidgetStyle(
        _ controller: WidgetSetupViewController,
        style: WidgetStyle
    )
    
    func widgetSetupViewControllerDidPressBack(
        _ viewController: WidgetSetupViewController,
        didMakeChanges: Bool
    )
    
    func widgetSetupViewControllerShouldPresentPreview(
        _ viewController: WidgetSetupViewController,
        for style: WidgetStyle
    )
    
    func widgetSetupViewControllerShouldPresentPurchasePreview(
        _ viewController: WidgetSetupViewController,
        for style: WidgetStyle
    )
        
}
