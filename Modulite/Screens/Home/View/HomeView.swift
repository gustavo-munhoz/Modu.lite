//
//  HomeView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit
import SnapKit

/// `HomeView` is a scrollable container view that includes three different sections, 
/// each represented by a `UICollectionView`.
/// These collections are used for displaying main widgets, auxiliary widgets, and tips respectively.
class HomeView: UIScrollView {
    
    // MARK: - Properties
    
    /// Container view that holds all subviews to enable vertical scrolling.
    private let contentView = UIView()
    
    /// Collection view for displaying main widgets.
    private(set) lazy var mainWidgetsCollectionView = createCollectionView(for: .mainWidgets)
    
    /// Collection view for displaying auxiliary widgets.
    private(set) lazy var auxiliaryWidgetsCollectionView = createCollectionView(for: .auxiliaryWidgets)
    
    /// Collection view for displaying tips.
    private(set) lazy var tipsCollectionView: UICollectionView = createCollectionView(for: .tips)
    
    /// Enumeration to define sections within the HomeView for better management.
    fileprivate enum ViewSection: Equatable {
        case mainWidgets
        case auxiliaryWidgets
        case tips
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteTurnip
        showsVerticalScrollIndicator = false
        
        addSubviews()
        setupConstraints()
        setupCollectionViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
        
    func setCollectionViewDelegates(to delegate: UICollectionViewDelegate) {
        mainWidgetsCollectionView.delegate = delegate
        auxiliaryWidgetsCollectionView.delegate = delegate
        tipsCollectionView.delegate = delegate
    }
        
    func setCollectionViewDataSources(to dataSource: UICollectionViewDataSource) {
        mainWidgetsCollectionView.dataSource = dataSource
        auxiliaryWidgetsCollectionView.dataSource = dataSource
        tipsCollectionView.dataSource = dataSource
    }
        
    private func setupCollectionViews() {
        mainWidgetsCollectionView.register(
            MainWidgetCollectionViewCell.self,
            forCellWithReuseIdentifier: MainWidgetCollectionViewCell.reuseId
        )
        mainWidgetsCollectionView.register(
            HomeHeaderReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderReusableCell.reuseId
        )
        
        auxiliaryWidgetsCollectionView.register(
            AuxiliaryWidgetCollectionViewCell.self,
            forCellWithReuseIdentifier: AuxiliaryWidgetCollectionViewCell.reuseId
        )
        auxiliaryWidgetsCollectionView.register(
            HomeHeaderReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderReusableCell.reuseId
        )
        
        tipsCollectionView.register(
            TipCollectionViewCell.self,
            forCellWithReuseIdentifier: TipCollectionViewCell.reuseId
        )
        tipsCollectionView.register(
            HomeHeaderReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderReusableCell.reuseId
        )
    }
    
    /// Adds all subviews to the contentView, which is then added to the UIScrollView.
    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(mainWidgetsCollectionView)
        contentView.addSubview(auxiliaryWidgetsCollectionView)
        contentView.addSubview(tipsCollectionView)
    }
        
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 24, left: 24, bottom: 0, right: -24)
            )
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(800)
        }
        
        mainWidgetsCollectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(300)
        }
        
        auxiliaryWidgetsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainWidgetsCollectionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(190)
        }
        
        tipsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(auxiliaryWidgetsCollectionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(210)
        }
    }
    
    // MARK: - Helper methods
    
    /// Calculates and returns the appropriate size for a given collection view layout section.
    private func getGroupSizeForCollectionViewLayout(for section: ViewSection) -> CGSize {
        switch section {
        case .mainWidgets: return CGSize(width: 192, height: 240)
        case .auxiliaryWidgets: return CGSize(width: 192, height: 130)
        case .tips: return CGSize(width: 200, height: 150)
        }
    }
    
    /// Creates and returns a collection view configured with a compositional layout based on the section type.
    private func createCollectionView(for section: ViewSection) -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout {
            [weak self] _, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
 
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 15
            )
            
            let size = self.getGroupSizeForCollectionViewLayout(for: section)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(size.width),
                heightDimension: .absolute(size.height)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [header]
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }
    
    // TODO: Implement this
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.frame = CGRect(x: 0, y: 0, width: bounds.width - 48, height: 2)
        
        return separator
    }
}
