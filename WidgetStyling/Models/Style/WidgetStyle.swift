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
    var backgroundConfiguration: StyleBackgroundConfiguration { get }
    var moduleConfiguration: StyleModuleConfiguration { get }
    var wallpaperConfiguration: StyleWallpaperConfiguration { get }
    var isPurchased: Bool { get }
    var isIncludedInPlus: Bool { get }
}
