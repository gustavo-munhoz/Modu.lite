//
//  PurchaseStylePreviewController.swift
//  Modulite
//
//  Created by André Wozniack on 02/11/24.
//

import UIKit
import WidgetStyling

protocol PurchaseStylePreviewControllerDelegate: AnyObject {
    func purchaseStylePreviewViewControllerDidPressUseStyle(
        _ viewController: PurchaseStylePreviewViewController
    )
}

class PurchaseStylePreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    private var styleView = PurchaseStylePreviewView()
    private var style: WidgetStyle
    var onStyleSelected: ((WidgetStyle) -> Void)?
    
    private var imageNames: [String] = []
    private var texts: [String] = []
    
    weak var delegate: PurchaseStylePreviewControllerDelegate?
    
    // MARK: - Initializers
    
    init(style: WidgetStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = styleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupCollectionView()
        setupViewActions()
    }
    
    // MARK: - Setup
    
    private func setupViewActions() {
        styleView.onBuyStylePressed = didPressSelectStyle
    }
    
    private func setupCollectionView() {
        styleView.collectionView.delegate = self
        styleView.collectionView.dataSource = self
        styleView.collectionView.register(ImagePreviewCell.self, forCellWithReuseIdentifier: ImagePreviewCell.reuseId)
    }
    
    private func configureView() {
        styleView.configure(with: style)
        imageNames = [
            "\(style.identifier)Preview1",
            "\(style.identifier)Preview2",
            "\(style.identifier)Preview3"
        ]
        
        texts = [
            "Lock Screen",
            "Home Screen\n(Main Widget)",
            "Home Screen\n(Main Widget + Auxiliary Widget)"
        ]
        
        styleView.pageControl.numberOfPages = imageNames.count
        styleView.collectionView.reloadData()
    }
    
    // MARK: - Actions
    private func didPressSelectStyle() {
        delegate?.purchaseStylePreviewViewControllerDidPressUseStyle(self)
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
