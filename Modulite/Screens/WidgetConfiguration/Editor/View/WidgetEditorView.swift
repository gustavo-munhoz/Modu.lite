//
//  WidgetEditorView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit
import SnapKit

class WidgetEditorView: UIScrollView {
    
    // MARK: - Properties
    
    var onDownloadWallpaperButtonTapped: (() -> Void)?
    var onSaveButtonTapped: (() -> Void)?
    
    private let contentView = UIView()
    
    private(set) lazy var layoutHeader: EditorSectionHeader = {
        let view = EditorSectionHeader()
        view.setTitleForKey(.widgetEditorViewWidgetLayoutTitle)
        
        return view
    }()
    
    private(set) lazy var widgetLayoutCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dragInteractionEnabled = true
        view.isScrollEnabled = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 21
        
        return view
    }()
    
    private(set) lazy var moduleStyleHeader: UILabel = {
        let view = UILabel()
        view.text = .localized(for: .widgetEditorViewWidgetModuleStyleTitle)
        view.font = UIFont(textStyle: .body, symbolicTraits: .traitBold.union(.traitItalic))
        
        return view
    }()
    
    private(set) lazy var moduleStyleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 145)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        layout.sectionInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .potatoYellow
        view.layer.cornerRadius = 20
        view.showsHorizontalScrollIndicator = false
        
        view.alpha = 0.55
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private(set) lazy var moduleColorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 37, height: 37)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.sectionInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .potatoYellow
        view.layer.cornerRadius = 20
        view.showsHorizontalScrollIndicator = false
        
        view.alpha = 0.55
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private(set) lazy var wallpaperHeader: EditorSectionHeader = {
        let view = EditorSectionHeader()
        view.setTitleForKey(.widgetEditorViewWidgetWallpaperTitle)
        
        return view
    }()
    
    private(set) lazy var downloadWallpaperButton: UIButton = {
        var config = UIButton.Configuration.bordered()
                
        config.attributedTitle = AttributedString(
            .localized(for: .widgetEditorViewWallpaperButton),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .bold),
                .foregroundColor: UIColor.black
            ])
        )
        
        config.titleAlignment = .center
        config.titleLineBreakMode = .byClipping
                
        config.image = UIImage(systemName: "square.and.arrow.down")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        
        config.imagePlacement = .leading
        config.imagePadding = 5
        
        config.baseBackgroundColor = .clear
        
        let view = UIButton(configuration: config)
        view.layer.borderColor = UIColor.carrotOrange.cgColor
        view.layer.borderWidth = 2
        
        view.configurationUpdateHandler = { button in
            var config = button.configuration
            
            UIView.animate(withDuration: 0.1) {
                switch button.state {
                case .highlighted:
                    button.alpha = 0.67
                    button.transform = .init(scaleX: 0.97, y: 0.97)
                    
                case .disabled:
                    button.alpha = 0.67
                    button.layer.borderColor = UIColor.gray.cgColor
                    config?.attributedTitle = AttributedString(
                        .localized(for: .widgetEditorViewWallpaperButtonSaved),
                        attributes: AttributeContainer([
                            .font: UIFont(textStyle: .body, weight: .bold),
                            .foregroundColor: UIColor.black
                        ])
                    )
                    
                    button.configuration = config
                    
                default:
                    button.alpha = 1
                    button.transform = .init(scaleX: 1, y: 1)
                }
            }
        }
        
        view.addTarget(self, action: #selector(didPressDownloadWallpaperButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var saveWidgetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .fiestaGreen
        
        config.attributedTitle = AttributedString(
            .localized(for: .widgetEditorViewSaveWidgetButton),
            attributes: AttributeContainer([
                .font: UIFont(textStyle: .body, weight: .bold),
                .foregroundColor: UIColor.white
            ])
        )
        
        config.image = UIImage(systemName: "envelope")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        
        config.imagePadding = 10
        
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(didPressSaveButton), for: .touchUpInside)
        view.layer.cornerRadius = 0
        
        return view
    }()
    
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
    
    func setWidgetBackground(to background: WidgetBackground) {
        switch background {
        case .image(let image):
            widgetLayoutCollectionView.backgroundView = UIImageView(image: image)
        case .color(let color):
            widgetLayoutCollectionView.backgroundColor = color
        }
    }
    
    func setCollectionViewDelegates(
        to delegate: UICollectionViewDelegate & UICollectionViewDragDelegate & UICollectionViewDropDelegate
    ) {
        widgetLayoutCollectionView.delegate = delegate
        widgetLayoutCollectionView.dragDelegate = delegate
        widgetLayoutCollectionView.dropDelegate = delegate
        moduleStyleCollectionView.delegate = delegate
        moduleColorCollectionView.delegate = delegate
    }
    
    func setCollectionViewDataSources(to dataSource: UICollectionViewDataSource) {
        widgetLayoutCollectionView.dataSource = dataSource
        moduleStyleCollectionView.dataSource = dataSource
        moduleColorCollectionView.dataSource = dataSource
    }
    
    func setLayoutHeaderInfoAction(_ action: @escaping () -> Void) {
        layoutHeader.onInfoButtonPressed = action
    }
    
    private func setupCollectionViews() {
        widgetLayoutCollectionView.register(
            WidgetModuleCell.self,
            forCellWithReuseIdentifier: WidgetModuleCell.reuseId
        )
        
        moduleStyleCollectionView.register(
            ModuleStyleCell.self,
            forCellWithReuseIdentifier: ModuleStyleCell.reuseId
        )
        
        moduleColorCollectionView.register(
            ModuleColorCell.self,
            forCellWithReuseIdentifier: ModuleColorCell.reuseId
        )
    }
    
    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(layoutHeader)
        contentView.addSubview(widgetLayoutCollectionView)
        contentView.addSubview(moduleStyleHeader)
        contentView.addSubview(moduleStyleCollectionView)
        contentView.addSubview(moduleColorCollectionView)
        contentView.addSubview(wallpaperHeader)
        contentView.addSubview(downloadWallpaperButton)
        contentView.addSubview(saveWidgetButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 24, left: 24, bottom: 24, right: -24))
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(900)
        }
        
        layoutHeader.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        
        widgetLayoutCollectionView.snp.makeConstraints { make in
            make.top.equalTo(layoutHeader.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(338)
            make.height.equalTo(354)
        }
        
        moduleStyleHeader.snp.makeConstraints { make in
            make.top.equalTo(widgetLayoutCollectionView.snp.bottom).offset(24)
            make.width.centerX.equalToSuperview()
        }
        
        moduleStyleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(moduleStyleHeader.snp.bottom).offset(15)
            make.height.equalTo(180)
            make.left.equalToSuperview()
            make.width.equalToSuperview().offset(44)
        }
        
        moduleColorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(moduleStyleCollectionView.snp.bottom).offset(24)
            make.height.equalTo(60)
            make.left.equalToSuperview()
            make.width.equalTo(moduleStyleCollectionView)
        }
        
        wallpaperHeader.snp.makeConstraints { make in
            make.top.equalTo(moduleColorCollectionView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        downloadWallpaperButton.snp.makeConstraints { make in
            make.top.equalTo(wallpaperHeader.snp.bottom).offset(16)
            make.width.equalTo(260)
            make.height.equalTo(40)
            make.left.equalTo(wallpaperHeader).inset(35)
        }
        
        saveWidgetButton.snp.makeConstraints { make in
            make.top.equalTo(downloadWallpaperButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(182)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    @objc private func didPressDownloadWallpaperButton() {
        onDownloadWallpaperButtonTapped?()
    }
    
    @objc private func didPressSaveButton() {
        onSaveButtonTapped?()
    }
    
    func updateCollectionViewConstraints(_ collectionView: UICollectionView, percentage: CGFloat) {
        let offset = 48 * percentage
        
        collectionView.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(-offset)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func enableStylingCollectionViews(didSelectEmptyCell value: Bool = false) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            if !value {
                self?.moduleStyleCollectionView.alpha = 1
                self?.moduleStyleCollectionView.isUserInteractionEnabled = true
            }
            
            self?.moduleColorCollectionView.alpha = 1
            self?.moduleColorCollectionView.isUserInteractionEnabled = true
        }
    }
    
    func disableStylingCollectionViews() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.moduleStyleCollectionView.alpha = 0.55
            self?.moduleColorCollectionView.alpha = 0.55
            self?.moduleStyleCollectionView.isUserInteractionEnabled = false
            self?.moduleColorCollectionView.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Helper methods
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.49)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: Array(repeating: item, count: 3)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            
            return section
        }
        
        return layout
    }
}
