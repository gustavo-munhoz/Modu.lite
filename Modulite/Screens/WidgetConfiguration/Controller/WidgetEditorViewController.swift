//
//  WidgetEditorViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetEditorViewController: UIViewController {
    
    private let editorView = WidgetEditorView()
    private let viewModel = WidgetEditorViewModel()
    
    override func loadView() {
        view = editorView
    }
    
}

extension WidgetEditorViewController {
    class func instantiate(widgetId: UUID, delegate: HomeNavigationFlowDelegate) -> WidgetEditorViewController {
        let vc = WidgetEditorViewController()
        vc.viewModel.setWidgetId(to: widgetId)
        vc.viewModel.setDelegate(to: delegate)
        
        return vc
    }
}
