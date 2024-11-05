//
//  WidgetStyle.swift
//  
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public protocol WidgetStyle {
    var identifier: String { get }
    var name: String { get }
    var preview: UIImage { get }
    var backgroundConfiguration: WidgetBackgroundConfiguration { get }
    var moduleConfiguration: WidgetModuleConfiguration { get }
    var wallpaperConfiguration: WidgetWallpaperConfiguration { get }
}
