//
//  WidgetSetupViewController+UICollectionViewDelegate.swift
//  Modulite
//
//  Created by André Wozniack on 04/11/24.
//

import UIKit
import WidgetStyling

// MARK: - UICollectionViewDelegate
extension WidgetSetupViewController: UICollectionViewDelegate {
    
    func selectStyle(_ style: WidgetStyle) {
        guard let index = viewModel.widgetStyles.firstIndex(where: {
            style.isEqual(to: $0)
        }) else { return }
        
        let indexPath = IndexPath(item: index, section: 1)
        
        viewModel.selectStyle(at: index)
        viewModel.setWidgetStyle(to: style)
        
        setupView.stylesCollectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: .centeredHorizontally
        )
        collectionView(self.setupView.stylesCollectionView, didSelectItemAt: indexPath)
        setupView.stylesCollectionView.reloadData()
    }
    
    func handleStylePurchase(for style: WidgetStyle) {
        let productID = style.identifier
        
        Task {
            do {
                guard let product = purchaseManager.getProduct(id: productID) else {
                    print("Product not found in purchase manager.")
                    return
                }
                
                try await purchaseManager.purchase(product: product)
                
                guard let style = viewModel.widgetStyles.first(
                    where: { $0.identifier == style.identifier }
                ) else { return }
                
                style.updateIsPurchased(to: true)
                print("Widget Style \(productID) purchased successfully.")
                selectStyle(style)
                delegate?.widgetSetupViewControllerDidSelectWidgetStyle(
                    self,
                    style: style
                )
                
                setupView.stylesCollectionView.reloadData()
                
            } catch PurchaseError.failedVerification {
                print("Falha na verificação da compra para o produto \(productID).")
                
            } catch PurchaseError.userCancelled {
                print("O usuário cancelou a compra do produto \(productID).")
                
            } catch PurchaseError.pending {
                print("A compra do produto \(productID) está pendente.")
                
            } catch {
                print("Erro ao comprar o estilo: \(error.localizedDescription)")
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard collectionView === setupView.stylesCollectionView else { return }
        guard indexPath.row >= 0, indexPath.row < viewModel.widgetStyles.count else { return }
        
        let widgetStyle = viewModel.widgetStyles[indexPath.row]
        
        if widgetStyle.isPurchased {
            guard let style = viewModel.selectStyle(at: indexPath.row) else { return }
            
            didMakeChangesToWidget = true
            setupView.isStyleSelected = true
            delegate?.widgetSetupViewControllerDidSelectWidgetStyle(self, style: style)
            scrollToSelectedStyle()
            
            if isOnboarding {
                Self.didSelectWidgetStyle.sendDonation()
            }
        } else {
            delegate?.widgetSetupViewControllerShouldPresentPurchasePreview(self, for: widgetStyle)
        }

        collectionView.reloadData()
    }
    
    func scrollToSelectedStyle() {
        guard let selectedStyleIndex = viewModel.getIndexForSelectedStyle() else { return }
        let selectedIndexPath = IndexPath(item: selectedStyleIndex, section: 1)
        setupView.stylesCollectionView.scrollToItem(
            at: selectedIndexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}
