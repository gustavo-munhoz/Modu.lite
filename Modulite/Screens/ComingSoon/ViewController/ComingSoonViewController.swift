//
//  ComingSoonViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 10/10/24.
//

import UIKit

class ComingSoonViewController: UIViewController {
    
    // MARK: - Properties
    private let comingSoonView = ComingSoonView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = comingSoonView
    }
    
    // MARK: - Setup Methods
    func fillComingSoonView(for feature: ComingSoonFeature) {
        comingSoonView.setup(
            iconName: feature.iconName,
            color: feature.color,
            titleKey: feature.titleKey,
            descriptionKey: feature.descriptionKey
        )
    }
}
