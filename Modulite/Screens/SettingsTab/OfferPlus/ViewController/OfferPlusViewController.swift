//
//  OfferPlusViewController.swift
//  Modulite
//
//  Created by André Wozniack on 13/11/24.
//

import UIKit

protocol OfferPlusViewControllerDelegate: AnyObject {
    func offerPlusViewControllerDidTapClose(
        _ viewController: OfferPlusViewController
    )
    func offerPlusViewControllerDidTapSubscribe(
        _ viewController: OfferPlusViewController,
        for option: OfferPlusView.SubscriptionOption
    )
}

class OfferPlusViewController: UIViewController {
    
    private var offerPlusView = OfferPlusView()
    weak var delegate: OfferPlusViewControllerDelegate?
    
    override func loadView() {
        view = offerPlusView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()

    }
    
    func setupViewActions() {
        offerPlusView.onSubscribe = didPressSubscribe
        offerPlusView.onClose = didPressClose
    }
    
    func didPressSubscribe(for option: OfferPlusView.SubscriptionOption) {
        delegate?.offerPlusViewControllerDidTapSubscribe(self, for: option)
    }
    
    func didPressClose() {
        delegate?.offerPlusViewControllerDidTapClose(self)
    }
}

extension OfferPlusViewController {
    static func instantiate(delegate: OfferPlusViewControllerDelegate) -> Self {
        let vc = Self()
        vc.delegate = delegate
        
        return vc
    }
}
