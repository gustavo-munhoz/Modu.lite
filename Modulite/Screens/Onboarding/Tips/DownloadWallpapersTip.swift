//
//  DownloadWallpapersTip.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 30/10/24.
//

import SwiftUI
import TipKit

struct DownloadWallpapersTip: Tip {
    var title: Text {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingDownloadWallpapersTitle)
        )
    }
    
    var message: Text? {
        Text(
            String.localized(for: OnboardingLocalizedTexts.onboardingDownloadWallpapersMessage)
        )
    }
    
    var rules: [Rule] {
        #Rule(WidgetEditorViewController.didEditModule) {
            $0.donations.count > 0
        }
    }
}
