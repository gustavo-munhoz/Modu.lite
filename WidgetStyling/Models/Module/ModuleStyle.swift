//
//  ModuleStyle.swift
//  
//
//  Created by Gustavo Munhoz Correa on 05/11/24.
//

import UIKit

public protocol ModuleStyle {
    var image: UIImage { get }
    var filterColors: [UIColor] { get }
    var defaultColor: UIColor { get }
    var imageBlendMode: CGBlendMode? { get }
    var textConfiguration: ModuleTextConfiguration { get }
}
