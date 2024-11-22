//
//  OfferPlusCoordinator.swift
//  Modulite
//
//  Created by André Wozniack on 13/11/24.
//
import Foundation

class OfferPlusCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismiss: (() -> Void)?) {
        let vc = OfferPlusViewController.instantiate(delegate: self)
        router.present(vc, animated: animated)
    }
    
    private func subscribe(to option: OfferPlusView.SubscriptionOption) async {
        guard let productID = getProductID(for: option),
              let product = SubscriptionManager.shared.getProduct(withID: productID) else {
            print("Produto não encontrado para a opção: \(option.rawValue)")
            return
        }
        
        SubscriptionManager.shared.purchase(subscription: product) { result in
            switch result {
            case .success:
                print("Inscrição concluída com sucesso para \(productID)")
                Task {
                    await MainActor.run {
                        self.dismiss(animated: true)
                    }
                }

            case .failure(let error):
                self.handleSubscriptionError(error)
            }
        }
    }
    
    private func handleSubscriptionError(_ error: SubscriptionError) {
        switch error {
        case .userCancelled:
            print("Usuário cancelou a transação.")
        case .failedVerification:
            print("Falha na verificação da transação.")
        case .pending:
            print("A transação está pendente.")
        case .unknown:
            print("Erro desconhecido durante a transação.")
        }
    }
    
    private func getProductID(for option: OfferPlusView.SubscriptionOption) -> String? {
        switch option {
        case .monthly:
            return "modulite.plus.monthly"
        case .year:
            return "modulite.plus.yearly"
        }
    }
}

extension OfferPlusCoordinator: OfferPlusViewControllerDelegate {
    func offerPlusViewControllerDidTapClose(
        _ viewController: OfferPlusViewController
    ) {
        dismiss(animated: true)
    }
    
    func offerPlusViewControllerDidTapSubscribe(
        _ viewController: OfferPlusViewController,
        for option: OfferPlusView.SubscriptionOption
    ) {
        Task {
            await subscribe(to: option)
        }
    }
}
