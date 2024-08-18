//
//  WidgetSetupView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit
import SnapKit

class WidgetSetupView: UIScrollView {
    
    // MARK: - Properties
    
    private let contentView = UIView()
    
    private(set) lazy var widgetNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Widget 1"
        textField.font = UIFont(textStyle: .title2, weight: .bold)
        textField.textColor = .textPrimary
        textField.backgroundColor = .beige
        
        textField.layer.cornerRadius = 12
        textField.setLeftPaddingPoints(15)
        
        return textField
    }()
    
    private(set) lazy var stylesCollectionView: UICollectionView = {
        let layout = createStylesCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private(set) lazy var selectedAppsCollectionView: UICollectionView = {
        let layout = createAppsCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        
        return collectionView
    }()
    
    private(set) lazy var nextViewButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .textPrimary
        config.baseBackgroundColor = .turquoise
        
        let view = UIButton(configuration: config)
        
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .screenBackground
        addSubviews()
        setupConstraints()
        setupTapGestures()
        setupCollectionViews()
        registerForKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    func setCollectionViewDataSources(to dataSource: UICollectionViewDataSource) {
        self.stylesCollectionView.dataSource = dataSource
        self.selectedAppsCollectionView.dataSource = dataSource
    }
    
    func setCollectionViewDelegates(to delegate: UICollectionViewDelegate) {
        self.stylesCollectionView.delegate = delegate
        self.selectedAppsCollectionView.delegate = delegate
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissiveTap))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupCollectionViews() {
        stylesCollectionView.register(
            StyleCollectionViewCell.self,
            forCellWithReuseIdentifier: StyleCollectionViewCell.reuseId
        
        )
        stylesCollectionView.register(
            SetupHeaderReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SetupHeaderReusableCell.reuseId
        )
                
        selectedAppsCollectionView.register(
            SelectedAppCollectionViewCell.self,
            forCellWithReuseIdentifier: SelectedAppCollectionViewCell.reuseId
        
        )
        
        selectedAppsCollectionView.register(
            SetupHeaderReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SetupHeaderReusableCell.reuseId
        )
    }
    
    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(widgetNameTextField)
        contentView.addSubview(stylesCollectionView)
        contentView.addSubview(selectedAppsCollectionView)
        contentView.addSubview(nextViewButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 24, left: 24, bottom: 0, right: -24))
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(700)
        }
        
        widgetNameTextField.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(37)
        }
        
        stylesCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(widgetNameTextField.snp.bottom).offset(24)
            make.height.equalTo(270)
        }
        
        selectedAppsCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stylesCollectionView.snp.bottom).offset(12)
            make.height.equalTo(280)
        }
        
        nextViewButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(selectedAppsCollectionView.snp.bottom).offset(18)
            make.width.equalTo(130)
            make.height.equalTo(45)
        }
    }
    
    // MARK: - Actions
    @objc private func handleDismissiveTap() {
        endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if frame.origin.y == 0 && !widgetNameTextField.isFirstResponder {
                UIView.animate(
                    withDuration: 0.25,
                    delay: 0,
                    options: .curveEaseInOut
                ) { [weak self] in
                    self?.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if frame.origin.y != 0 {
            frame.origin.y = 0
        }
    }
    
    // MARK: - Helper methods
    private func createStylesCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(192),
                heightDimension: .absolute(234)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(40)
            )
            
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
    
    private func createAppsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
                        
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
                        
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(34)
            )
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                        
            let section = NSCollectionLayoutSection(group: group)
                        
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(90)
            )
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.pinToVisibleBounds = true
            
            section.boundarySupplementaryItems = [header]
            return section
        }
        return layout
    }
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
