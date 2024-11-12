//
//  WidgetSetupView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit
import SnapKit
import WidgetStyling

class WidgetSetupView: UIScrollView {
    
    // MARK: - Properties
    
    var onSearchButtonPressed: (() -> Void)?
    var onNextButtonPressed: (() -> Void)?
    
    var isStyleSelected = false
    var hasAppsSelected = false
    
    private let contentView = UIView()
    
    private(set) lazy var widgetNameTextField: UITextField = {
        let textField = UITextField()
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
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    // TODO: Create custom view with app count
    private(set) lazy var selectAppsTitle = UILabel()
    
    private(set) lazy var searchAppsButton: UIButton = {
        let button = ButtonFactory.mediumButton(
            titleKey: String.LocalizedKey.widgetSetupViewSearchAppsButtonTitle,
            image: UIImage(systemName: "magnifyingglass"),
            imagePointSize: 17,
            backgroundColor: .carrotOrange
        )
                
        button.addTarget(self, action: #selector(handleSearchButtonPressed), for: .touchUpInside)
        
        return button
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
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private(set) lazy var nextViewButton: UIButton = {
        let button = ButtonFactory.smallButton(
            titleKey: String.LocalizedKey.next,
            image: UIImage(systemName: "arrow.right")
        )
        
        button.addTarget(self, action: #selector(handleNextButtonPressed), for: .touchUpInside)
        button.configurationUpdateHandler = { [weak self] btn in
            guard let self = self, var config = btn.configuration else { return }
            
            btn.isEnabled = self.isStyleSelected && self.hasAppsSelected
            
            switch btn.state {
            case .disabled:
                config.background.backgroundColor = .systemGray2
                
            case .highlighted:
                button.transform = .init(scaleX: 0.97, y: 0.97)
                button.imageView?.addSymbolEffect(.bounce)
                button.alpha = 0.67
            default:
                button.transform = .identity
                button.alpha = 1
                config.background.backgroundColor = .blueberry
            }
            
            btn.configuration = config
        }
        
        return button
    }()
    
    // MARK: - Actions
    func getWidgetName() -> String {
        guard let name = widgetNameTextField.text, !name.isEmpty else {
            return widgetNameTextField.placeholder!
        }
        
        return widgetNameTextField.text!
    }
    
    func updateButtonConfig() {
        nextViewButton.setNeedsUpdateConfiguration()
    }
    
    @objc private func handleBackgroundTap() {
        endEditing(true)
    }
    
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
        setupTapGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    func setupWidgetNamePlaceholder(_ placeholder: String) {
        widgetNameTextField.placeholder = placeholder
    }
    
    func setupSetupSelectAppsTitle(maxsAppsCount: Int) {
        selectAppsTitle.attributedText = CustomizedTextFactory.createTextWithAsterisk(
            with: .localized(
                for: .widgetSetupViewAppsHeaderTitle(maxApps: maxsAppsCount)
            )
        )
    }
    
    func setupStyleCollectionViewHeight(_ height: CGFloat) {
        stylesCollectionView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    func setupStyleCellHeight(_ height: CGFloat) {
        stylesCollectionView.collectionViewLayout = WidgetSetupStyleCompositionalLayout(
            stylesHeight: height
        )
    }
    
    func updateSelectedAppsCollectionViewHeight() {
        selectedAppsCollectionView.snp.updateConstraints { make in
            make.height.greaterThanOrEqualTo(selectedAppsCollectionView.contentSize.height)
        }
    }
    
    func setWidgetNameTextFieldDelegate(to delegate: UITextFieldDelegate) {
        self.widgetNameTextField.delegate = delegate
    }
    
    func setCollectionViewDataSources(to dataSource: UICollectionViewDataSource) {
        self.stylesCollectionView.dataSource = dataSource
        self.selectedAppsCollectionView.dataSource = dataSource
    }
    
    func setCollectionViewDelegates(to delegate: UICollectionViewDelegate) {
        self.stylesCollectionView.delegate = delegate
        self.selectedAppsCollectionView.delegate = delegate
    }
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
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
        contentView.addSubview(selectAppsTitle)
        contentView.addSubview(searchAppsButton)
        contentView.addSubview(selectedAppsCollectionView)
        contentView.addSubview(searchAppsHelperText)
        contentView.addSubview(nextViewButton)
    }
    
    #warning("Depends on widget type")
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 24, left: 24, bottom: 0, right: -24)
            )
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
            make.width.equalTo(220)
            make.height.greaterThanOrEqualTo(32)
            make.bottom.equalTo(nextViewButton.snp.top).offset(-21)
        }
        
        nextViewButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
