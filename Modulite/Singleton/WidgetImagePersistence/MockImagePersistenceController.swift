//
//  MockImagePersistenceController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 17/09/24.
//

import UIKit

class MockImagePersistenceController: WidgetImagePersistenceController {
    var widgetImages: [UUID: UIImage] = [:]
    var moduleImages: [UUID: [Int: UIImage]] = [:]
    
    func saveWidgetImage(image: UIImage, for widgetId: UUID) -> URL {
        widgetImages[widgetId] = image
        return URL(string: "mock://widget/\(widgetId)")!
    }
    
    func getWidgetImage(with id: UUID) -> UIImage? {
        return widgetImages[id]
    }
    
    func deleteWidgetAndModules(with id: UUID) {
        widgetImages.removeValue(forKey: id)
        moduleImages.removeValue(forKey: id)
    }
    
    func saveModuleImage(image: UIImage, for widgetId: UUID, moduleIndex: Int) -> URL {
        if moduleImages[widgetId] == nil {
            moduleImages[widgetId] = [:]
        }
        moduleImages[widgetId]?[moduleIndex] = image
        return URL(string: "mock://widget/\(widgetId)/module/\(moduleIndex)")!
    }
}
