//
//  IsStyleIncludedInPlusSpecification.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import WidgetStyling

struct IsStyleIncludedInPlusSpecification: Specification {
    let styleIdentifier: String

    func isSatisfied() -> Bool {
        do {
            let provider = try WidgetStyleProvider()
            let plusStyles = provider.getStylesContainedInPlus()
            
            return plusStyles
                .map { $0.identifier }
                .contains(styleIdentifier)
            
        } catch {
            print("Error checking specification: \(error.localizedDescription)")
            return false
        }
    }
}
