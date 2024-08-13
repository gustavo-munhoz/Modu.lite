//
//  HomeView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    // MARK: - Properties
    private(set) lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            mainWidgetsCollectionView,
            auxiliaryWidgetsCollectionView,
            tipsCollectionView
        ])
//        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        return stack
    }()
    
    private(set) lazy var mainWidgetsCollectionView: UICollectionView = createCollectionView(for: .mainWidgets)
    private(set) lazy var auxiliaryWidgetsCollectionView: UICollectionView = createCollectionView(for: .auxiliaryWidgets)
    private(set) lazy var tipsCollectionView: UICollectionView = createCollectionView(for: .tips)
    
    fileprivate enum ViewSection: Equatable {
        case mainWidgets
        case auxiliaryWidgets
        case tips
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .screenBackground
        
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
    
    private func getGroupSizeForCollectionViewLayout(for section: ViewSection) -> CGSize {
        switch section {
        case .mainWidgets: return CGSizeMake(192, 235)
        case .auxiliaryWidgets: return CGSizeMake(192, 130)
        case .tips: return CGSizeMake(200, 150)
        }
    }
    
    private func createCollectionView(for section: ViewSection) -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let size = getGroupSizeForCollectionViewLayout(for: section)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(size.width), heightDimension: .absolute(size.height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }

    
    private func setupCollectionViews() {
        mainWidgetsCollectionView.register(MainWidgetCollectionViewCell.self, forCellWithReuseIdentifier: MainWidgetCollectionViewCell.reuseId)
        mainWidgetsCollectionView.register(HeaderReusableCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCell.reuseId)
        
        auxiliaryWidgetsCollectionView.register(AuxiliaryWidgetCollectionViewCell.self, forCellWithReuseIdentifier: AuxiliaryWidgetCollectionViewCell.reuseId)
        auxiliaryWidgetsCollectionView.register(HeaderReusableCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCell.reuseId)
        
        tipsCollectionView.register(TipCollectionViewCell.self, forCellWithReuseIdentifier: TipCollectionViewCell.reuseId)
        tipsCollectionView.register(HeaderReusableCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCell.reuseId)
    }
    
    private func addSubviews() {
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(24)
        }
    }
}
