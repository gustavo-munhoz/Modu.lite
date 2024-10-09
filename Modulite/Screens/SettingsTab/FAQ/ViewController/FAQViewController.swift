//
//  FAQViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import UIKit

protocol FAQViewControllerDelegate: AnyObject {
}

class FAQViewController: UIViewController {
    
    // MARK: - Properties
    private let faqView = FAQView()
    private let viewModel = FAQViewModel()
    
    weak var delegate: FAQViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = faqView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        faqView.setQuestions(to: viewModel.questions)
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationItem.title = .localized(for: FAQLocalizedTexts.faqViewNavigationTitle)
    }
}

extension FAQViewController {
    static func instantiate(delegate: FAQViewControllerDelegate) -> Self {
        let vc = Self()
        vc.delegate = delegate
        
        return vc
    }
}
