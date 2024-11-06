//
//  WidgetStyleData.swift
//  WidgetStyling
//
//  Created by Gustavo Munhoz Correa on 06/11/24.
//

import Foundation

struct WidgetStyleData: Decodable {
    let identifier: String
    let name: String
    let previewImageName: String
    let isPurchased: Bool
    let isIncludedInPlus: Bool
    
    let backgroundConfiguration: StyleBackgroundConfigurationData
    let moduleConfiguration: StyleModuleConfigurationData
    let wallpaperSet: WallpaperSetData
}
