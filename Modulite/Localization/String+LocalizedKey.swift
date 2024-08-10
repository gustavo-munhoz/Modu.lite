//
//  String+LocalizedKey.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import Foundation

extension String {
    
    enum LocalizedKey {
        case example(value: Int)
        case example2
        
        fileprivate var key: String {
            if let nameRemovingValues = Mirror(reflecting: self).children.first?.label {
                return nameRemovingValues
            }
            
            return String(describing: self)
        }
        
        fileprivate var values: [CVarArg] {
            switch self {
            
            default:
                return []
            }
        }
    }
    
    static func localized(for key: LocalizedKey) -> String {
        String(format: NSLocalizedString(key.key, comment: ""), arguments: key.values)
    }
}
