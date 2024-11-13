//
//  OfferPlusViewController.swift
//  Modulite
//
//  Created by André Wozniack on 13/11/24.
//

import UIKit

protocol OfferPlusViewControllerDelegate: AnyObject {
    func offerPlusViewControllerDidTapClose(_ viewController: OfferPlusViewController)
    
}


class OfferPlusViewController: UIViewController {
    
    private var offerPlusView = OfferPlusView()
    
    override func loadView() {
        view = offerPlusView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
