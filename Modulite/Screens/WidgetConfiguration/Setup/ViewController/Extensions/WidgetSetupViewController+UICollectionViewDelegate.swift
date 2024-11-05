//
//  WidgetSetupViewController+UICollectionViewDelegate.swift
//  Modulite
//
//  Created by André Wozniack on 04/11/24.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension WidgetSetupViewController: UICollectionViewDelegate {
    
    func selectStyle(_ style: WidgetStyle) {
        guard let index = viewModel.widgetStyles.firstIndex(of: style) else { return }
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
        let productID = style.key.rawValue
        Task {
            do {
                let products = try await purchaseManager.fetchProducts()
                if let product = products.first(where: { $0.id == productID }) {
                    try await purchaseManager.purchase(product: product)
                    
                    if let index = viewModel.widgetStyles.firstIndex(where: { $0.key == style.key }) {
                        viewModel.widgetStyles[index].isPurchased = true
                        print("Widget \(productID) purchase successful")
                        selectStyle(viewModel.widgetStyles[index])
                    }
                    setupView.stylesCollectionView.reloadData()
                    
                } else {
                    print("Produto não encontrado")
                }
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
