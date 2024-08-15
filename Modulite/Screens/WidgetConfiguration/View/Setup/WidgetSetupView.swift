//
//  WidgetSetupView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit
import SnapKit

class WidgetSetupView: UIView {
    
    // MARK: - Properties
    
    private(set) lazy var widgetNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Widget 1"
        textField.font = UIFont(textStyle: .title2, weight: .bold)
        textField.textColor = .textPrimary
        textField.backgroundColor = .beige
        
        textField.layer.cornerRadius = 18
        textField.setLeftPaddingPoints(20)
        
        return textField
    }()
    
    private(set) lazy var stylesCollectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .screenBackground
        addSubviews()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    func setCollectionViewDataSources(to dataSource: UICollectionViewDataSource) {
        self.stylesCollectionView.dataSource = dataSource
    }
    
    func setCollectionViewDelegates(to delegate: UICollectionViewDelegate) {
        self.stylesCollectionView.delegate = delegate
    }
    
    private func setupCollectionView() {
        stylesCollectionView.register(
            StyleCollectionViewCell.self,
            forCellWithReuseIdentifier: StyleCollectionViewCell.reuseId
        
        )
        stylesCollectionView.register(
            SetupHeaderReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SetupHeaderReusableCell.reuseId
        )
    }
    
    private func addSubviews() {
        addSubview(widgetNameTextField)
        addSubview(stylesCollectionView)
    }
    
    private func setupConstraints() {
        widgetNameTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(37)
        }
        
        stylesCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(widgetNameTextField)
            make.top.equalTo(widgetNameTextField.snp.bottom).offset(24)
            make.height.equalTo(270)
        }
    }
    
    // MARK: - Helper methods
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(192), heightDimension: .absolute(234))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
}
