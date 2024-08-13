//
//  HomeView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit
import SnapKit

/// `HomeView` acts as a scrollable container for managing a collection of widgets and tips.
/// It encapsulates the complexity of handling layout and scroll behaviors within a vertically scrollable area.
class HomeView: UIScrollView {
    
    // MARK: - Subviews

    /// `contentView` serves as a container for all subviews, allowing for consistent layout management within the scrollable area.
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// `collectionView` manages the horizontal display and interaction of widgets and tips, supporting reusable cell views.
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .screenBackground
        isScrollEnabled = true
        
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    /// Adds subviews to the `contentView`.
    private func addSubviews() {
        contentView.addSubview(collectionView)
    }
    
    /// Configures the constraints for `collectionView` to pin it to the edges of the `contentView`.
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// Sets up the scrollView including adding and laying out the `contentView`.
    private func setupScrollView() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.left.right.equalTo(self)
            make.width.equalTo(self)
            make.height.greaterThanOrEqualTo(self).priority(.low)
        }
        
        addSubviews()
        setupConstraints()
    }
    
    /// Configures `collectionView` by registering cell and view types used within the collection.
    private func setupCollectionView() {
        collectionView.register(
            MainWidgetCollectionViewCell.self,
            forCellWithReuseIdentifier: MainWidgetCollectionViewCell.reuseId
        )
        
        collectionView.register(
            AuxiliaryWidgetCollectionViewCell.self,
            forCellWithReuseIdentifier: AuxiliaryWidgetCollectionViewCell.reuseId
        )
        
        collectionView.register(
            TipCollectionViewCell.self,
            forCellWithReuseIdentifier: TipCollectionViewCell.reuseId
        )
        
        collectionView.register(
            HeaderReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableCell.reuseId
        )
    }
}
