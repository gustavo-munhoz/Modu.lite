//
//  RedirectingViewController.swift
//  Modulite
//
//  Created by André Wozniack on 29/10/24.
//

import UIKit

class RedirectingViewController: UIViewController {
    
    private var redirectingView = RedirectingView()
    
    override func loadView() {
        view = redirectingView
    }
    
    func showAlert(completion: @escaping () -> Void) {
        let cantOpenVC = CantOpenAppViewController()
        cantOpenVC.modalPresentationStyle = .overCurrentContext
        cantOpenVC.modalTransitionStyle = .crossDissolve
        
        cantOpenVC.onOkPressed = { [weak self] in
            self?.dismiss(animated: false)
            completion()
        }
        
        present(cantOpenVC, animated: false)
    }
}
