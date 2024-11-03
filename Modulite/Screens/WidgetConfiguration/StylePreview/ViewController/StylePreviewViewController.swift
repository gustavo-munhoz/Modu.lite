//
//  StylePreviewViewController.swift
//  Modulite
//
//  Created by André Wozniack on 30/10/24.
//

import UIKit

class StylePreviewViewController: UIViewController {
    
    private var styleView = StylePreviewView()
    private var viewModel = StylePreviewViewModel()
    private var style: WidgetStyle
    var onStyleSelected: ((WidgetStyle) -> Void)?
    
    private var imageNames: [String] = []
    private var texts: [String] = []
    
    init(style: WidgetStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
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
        
        styleView.selectStyleButtonPressed = { [weak self] in
            guard let self = self else { return }
            self.onStyleSelected?(self.style)
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
}

extension StylePreviewViewController: UICollectionViewDataSource {
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

extension StylePreviewViewController: UICollectionViewDelegateFlowLayout {
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
