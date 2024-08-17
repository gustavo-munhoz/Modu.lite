//
//  WidgetEditorViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetEditorViewController: UIViewController {
    
    private var editorView = WidgetEditorView()
    
    override func loadView() {
        view = editorView
    }
    
}
