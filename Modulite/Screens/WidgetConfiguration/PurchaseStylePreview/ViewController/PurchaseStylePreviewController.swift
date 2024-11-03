//
//  PurchaseStylePreviewController.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import UIKit

protocol PurchaseStylePreviewControllerDelegate: AnyObject {
    func didCompletePurchase(for productId: String)
    func didFailPurchase(for productId: String, error: Error?)
    func didRestorePurchase(for productId: String)
}

class PurchaseStylePreviewViewController: UIViewController {
    
    private var styleView = PurchaseStylePreviewView()
    private var style: WidgetStyle
    var onStyleSelected: ((WidgetStyle) -> Void)?
    
    private var imageNames: [String] = []
    private var texts: [String] = []
    
    init(style: WidgetStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        
        PurchasedSkinsManager.shared.onPurchaseCompleted = { [weak self] productId in
            self?.handlePurchaseSuccess(productId: productId)
        }
        
        PurchasedSkinsManager.shared.onPurchaseFailed = { [weak self] productId, error in
            self?.handlePurchaseFailure(productId: productId, error: error)
        }
        
        PurchasedSkinsManager.shared.onPurchaseRestored = { [weak self] productId in
            self?.handlePurchaseRestored(productId: productId)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSkinPurchased(_:)),
            name: .skinPurchased,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(skinsLoaded),
            name: .skinsLoaded,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = styleView
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        styleView.buyStyleButtonPressed = { [weak self] in
            guard let self = self else { return }
            self.fetchAndPurchaseSkin()
        }
    }
    
    private func setupCollectionView() {
        styleView.collectionView.delegate = self
        styleView.collectionView.dataSource = self
        styleView.collectionView.register(ImagePreviewCell.self, forCellWithReuseIdentifier: ImagePreviewCell.reuseId)
    }
    
    private func configureView() {
        styleView.configure(with: style)
        
        imageNames = [
            "\(style.name.lowercased())Preview1",
            "\(style.name.lowercased())Preview2",
            "\(style.name.lowercased())Preview3"
        ]
        
        texts = [
            "Lock Screen",
            "Home Screen\n(Main Widget)",
            "Home Screen\n(Main Widget + Auxiliary Widget)"
        ]
        
        styleView.pageControl.numberOfPages = imageNames.count
        styleView.collectionView.reloadData()
    }
    
    // MARK: - Fetch and Purchase Skin
    private func fetchAndPurchaseSkin() {
        PurchasedSkinsManager.shared.fetchAvailableSkins(productIds: [style.key.rawValue])
    }
    
    @objc private func skinsLoaded() {
        PurchasedSkinsManager.shared.purchaseSkin(with: style.key.rawValue)
    }
    
    // MARK: - Handle Skin Purchase Notification
    @objc private func handleSkinPurchased(_ notification: Notification) {
        guard let purchasedProductId = notification.object as? String else { return }
        
        if purchasedProductId == style.key.rawValue {
            style.isPurchased = true
            onStyleSelected?(style)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - Callbacks for Purchase Handling
    private func handlePurchaseSuccess(productId: String) {
        if productId == style.key.rawValue {
            style.isPurchased = true
            onStyleSelected?(style)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func handlePurchaseFailure(productId: String, error: Error?) {
        if productId == style.key.rawValue {
            let errorMessage = error?.localizedDescription ?? "Compra falhou."
            let alert = UIAlertController(title: "Erro", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func handlePurchaseRestored(productId: String) {
        if productId == style.key.rawValue {
            style.isPurchased = true
            onStyleSelected?(style)
            dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PurchaseStylePreviewViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return imageNames.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImagePreviewCell.reuseId,
            for: indexPath
        ) as? ImagePreviewCell else {
            return UICollectionViewCell()
        }
        
        let image = UIImage(named: imageNames[indexPath.item])
        let text = texts[indexPath.item]
        cell.configure(with: image, text: text)
        return cell
    }
}

extension PurchaseStylePreviewViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / styleView.collectionView.frame.width)
        styleView.pageControl.currentPage = Int(pageIndex)
    }
}
