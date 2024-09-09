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
    
    var onSearchButtonPressed: (() -> Void)?
    var onNextButtonPressed: (() -> Void)?
    
    private let contentView = UIView()
    
    private(set) lazy var widgetNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Widget 1"
        textField.font = UIFont(textStyle: .title2, weight: .bold)
        textField.textColor = .textPrimary
        textField.backgroundColor = .potatoYellow
        
        textField.layer.cornerRadius = 12
        textField.setLeftPaddingPoints(15)
        
        return textField
    }()
    
    private(set) lazy var stylesCollectionView: UICollectionView = {
        let layout = WidgetSetupStyleCompositionalLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    // TODO: Create custom view with app count
    private(set) lazy var selectAppsTitle: UILabel = {
        let label = UILabel()
        label.attributedText = CustomizedTextFactory.createTextWithAsterisk(
            with: .localized(for: .widgetSetupViewAppsHeaderTitle)
        )
        
        return label
    }()
    
    private(set) lazy var searchAppsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .carrotOrange
        config.title = .localized(for: .widgetSetupViewSearchAppsButtonTitle)
        config.image = UIImage(systemName: "magnifyingglass")
        config.imagePadding = 10
        
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(handleSearchButtonPressed), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var selectedAppsCollectionView: UICollectionView = {
        let layout = WidgetSetupAppsTagFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private(set) lazy var searchAppsHelperText: UILabel = {
        let label = UILabel()
        
        label.text = .localized(for: .widgetSetupViewSearchAppsHelperText)
        label.font = UIFont(textStyle: .caption1, symbolicTraits: .traitItalic)
        label.textColor = .systemGray
        label.numberOfLines = -1
        
        return label
    }()
    
    private(set) lazy var nextViewButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .fiestaGreen
        config.title = .localized(for: .next)
        config.imagePlacement = .trailing
        config.image = UIImage(systemName: "arrow.right")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = .init(pointSize: 20, weight: .bold)
        config.baseForegroundColor = .white
        // TODO: Finish customizations
        
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(handleNextButtonPressed), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Actions
    @objc private func handleSearchButtonPressed() {
        onSearchButtonPressed?()
    }
    
    @objc private func handleNextButtonPressed() {
        onNextButtonPressed?()
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
    
    func updateSelectedAppsCollectionViewHeight() {
        selectedAppsCollectionView.snp.updateConstraints { make in
            make.height.greaterThanOrEqualTo(selectedAppsCollectionView.contentSize.height)
        }
    }
    
    func setCollectionViewDataSources(to dataSource: UICollectionViewDataSource) {
        self.stylesCollectionView.dataSource = dataSource
        self.selectedAppsCollectionView.dataSource = dataSource
    }
    
    func setCollectionViewDelegates(to delegate: UICollectionViewDelegate) {
        self.stylesCollectionView.delegate = delegate
        self.selectedAppsCollectionView.delegate = delegate
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
        contentView.addSubview(selectAppsTitle)
        contentView.addSubview(searchAppsButton)
        contentView.addSubview(selectedAppsCollectionView)
        contentView.addSubview(searchAppsHelperText)
        contentView.addSubview(nextViewButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 24, bottom: 0, right: -24))
            make.width.equalToSuperview().offset(-48)
            make.height.greaterThanOrEqualTo(700).priority(.required)
        }
        
        widgetNameTextField.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(37)
        }
        
        stylesCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(widgetNameTextField.snp.bottom).offset(16)
            make.height.equalTo(270)
        }
        
        selectAppsTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stylesCollectionView.snp.bottom).offset(24)
        }
        
        searchAppsButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(230)
            make.height.equalTo(45)
            make.top.equalTo(selectAppsTitle.snp.bottom).offset(15)
        }
        
        selectedAppsCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchAppsButton.snp.bottom).offset(20)
            make.bottom.equalTo(searchAppsHelperText.snp.top).offset(-12)
            make.height.greaterThanOrEqualTo(150)
        }
        
        searchAppsHelperText.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(32)
            make.bottom.equalTo(nextViewButton.snp.top).offset(-21)
        }
        
        nextViewButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(45)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func handleDismissiveTap() {
        endEditing(true)
    }
}
