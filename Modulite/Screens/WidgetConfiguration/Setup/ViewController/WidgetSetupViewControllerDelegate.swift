//
//  WidgetSetupViewControllerDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import UIKit

protocol WidgetSetupViewControllerDelegate: AnyObject {
    func getPlaceholderName() -> String
    
    func widgetSetupViewControllerDidPressNext(widgetName: String)
    
    func widgetSetupViewControllerDidTapSearchApps(
        _ parentController: WidgetSetupViewController
    )
    
    func widgetSetupViewControllerDidDeselectApp(
        _ controller: WidgetSetupViewController,
        app: AppInfo
    )
    
    func widgetSetupViewControllerDidSelectWidgetStyle(
        _ controller: WidgetSetupViewController,
        style: WidgetStyle
    )
    
    func widgetSetupViewControllerDidPressBack(
        _ viewController: WidgetSetupViewController,
        didMakeChanges: Bool
    )
}