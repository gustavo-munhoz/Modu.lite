//
//  HelpCoordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/10/24.
//

import Foundation
import MessageUI

class HelpCoordinator: NSObject, Coordinator {
    var children: [Coordinator] = []
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = HelpViewController.instantiate(delegate: self)
        vc.hidesBottomBarWhenPushed = true
        
        router.present(vc, animated: true)
    }
}

// MARK: - HelpViewControllerDelegate
extension HelpCoordinator: HelpViewControllerDelegate {
    func helpViewControllerDidPressReportIssue(_ viewController: HelpViewController) {
        presentMailComposeViewController(with: viewController)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension HelpCoordinator: MFMailComposeViewControllerDelegate {
    private func presentEmailErrorAlert(with parent: UIViewController) {
        let alert = UIAlertController(
            title: .localized(for: HelpLocalizedTexts.helpViewSendEmailErrorAlertTitle),
            message: .localized(for: HelpLocalizedTexts.helpViewSendEmailErrorAlertMessage),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: .localized(for: .ok).uppercased(),
            style: .default
        ))
        
        parent.present(alert, animated: true)
    }
    
    private func presentMailComposeViewController(with parent: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            presentEmailErrorAlert(with: parent)
            return
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["deftmango@gmail.com"])
        mailComposeVC.setSubject(
            .localized(for: HelpLocalizedTexts.helpViewSendEmailSubject)
        )
        mailComposeVC.setMessageBody(
            .localized(for: HelpLocalizedTexts.helpViewSendEmailBody),
            isHTML: true
        )
        
        parent.present(mailComposeVC, animated: true)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true, completion: nil)
    }
}
