//
//  WidgetEditorView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit
import SnapKit
import WidgetStyling

class WidgetEditorView: UIView {
         
    // MARK: - Properties
    var onDownloadWallpaperButtonTapped: (() -> Void)?
    var onSaveButtonTapped: (() -> Void)?
    var onDeleteButtonTapped: (() -> Void)?
    
    private var isEditing: Bool = false {
        didSet {
            guard isEditing else { return }
            
            remakeConstraintsToInsertDeleteButton()
            saveWidgetButton.setToEditingState()
        }
    }
    
    private let scrollView = UIScrollView()
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
        layout.itemSize = CGSize(width: 108 * 0.8, height: 170 * 0.8)
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
    
    private(set) lazy var downloadWallpaperButton: WidgetEditorDownloadButton = {
        let button = WidgetEditorDownloadButton()
        button.addTarget(self, action: #selector(didPressDownloadWallpaperButton), for: .touchUpInside)
        
        return button
    }()
    
    private(set) lazy var saveWidgetButton: WidgetEditorSaveButton = {
        let button = WidgetEditorSaveButton()
        button.addTarget(self, action: #selector(didPressSaveButton), for: .touchUpInside)
        
        return button
    }()
    
    private(set) lazy var deleteWidgetButton: UIButton = {
        let button = WidgetEditorDeleteButton()
        button.addTarget(self, action: #selector(didPressDeleteButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteTurnip
        
        setupViews()
        setupConstraints()
        setupCollectionViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup methods

    func setScrollViewDelegate(to delegate: UIScrollViewDelegate) {
        scrollView.delegate = delegate
    }

    func setupCollectionViewLayout(with strategy: WidgetTypeStrategy) {
        widgetLayoutCollectionView.collectionViewLayout = createCompositionalLayout(for: strategy)
    }
    
    func setupLayoutCollectionViewSize(_ size: CGSize) {
        widgetLayoutCollectionView.snp.makeConstraints { make in
            make.height.equalTo(size.height)
            make.width.equalTo(size.width)
        }
    }

    func setupModuleStyleItemSize(_ size: CGSize) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        layout.sectionInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        
        moduleStyleCollectionView.collectionViewLayout = layout
    }
    
    func setLayoutInfoButtonAction(_ action: @escaping () -> Void) {
        layoutHeader.onInfoButtonPressed = action
    }
    
    func setWallpaperInfoButtonAction(_ action: @escaping () -> Void) {
        wallpaperHeader.onInfoButtonPressed = action
    }
    
    func setEditingMode(to value: Bool) {
        isEditing = value
    }
    
    private func remakeConstraintsToInsertDeleteButton() {
        contentView.addSubview(deleteWidgetButton)
        
        saveWidgetButton.snp.removeConstraints()
        
        saveWidgetButton.snp.makeConstraints { make in
            make.top.equalTo(downloadWallpaperButton.snp.bottom).offset(24)
            make.height.equalTo(44)
            make.width.equalTo(130)
            make.right.equalToSuperview().inset(24)
        }
        
        deleteWidgetButton.snp.removeConstraints()
        
        deleteWidgetButton.snp.makeConstraints { make in
            make.top.equalTo(saveWidgetButton)
            make.height.width.equalTo(saveWidgetButton)
            make.left.equalToSuperview().inset(24)
            make.right.lessThanOrEqualTo(saveWidgetButton.snp.left).offset(-30)
        }
    }
    
    func setWidgetBackground(to background: StyleBackground) {
        switch background {
        case .image(let image):
            widgetLayoutCollectionView.backgroundView = UIImageView(image: image)
        case .color(let color):
            widgetLayoutCollectionView.backgroundColor = color
        @unknown default:
            break
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
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
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
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView.contentLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-48)
        }
        
        layoutHeader.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        
        widgetLayoutCollectionView.snp.makeConstraints { make in
            make.top.equalTo(layoutHeader.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        moduleStyleHeader.snp.makeConstraints { make in
            make.top.equalTo(widgetLayoutCollectionView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        moduleStyleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(moduleStyleHeader.snp.bottom).offset(15)
            make.height.equalTo(190)
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
            make.centerX.equalToSuperview()
        }
        
        saveWidgetButton.snp.makeConstraints { make in
            make.top.equalTo(downloadWallpaperButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(182)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    // MARK: - Actions
    @objc private func didPressDownloadWallpaperButton() {
        onDownloadWallpaperButtonTapped?()
    }
    
    @objc private func didPressSaveButton() {
        onSaveButtonTapped?()
    }
    
    @objc private func didPressDeleteButton() {
        onDeleteButtonTapped?()
    }
    
    func updateCollectionViewConstraints(_ collectionView: UICollectionView, percentage: CGFloat) {
        let offset = 48 * percentage

        collectionView.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(-offset)
        }

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            self.layoutIfNeeded()
        }
    }
    
    func enableStylingCollectionViews(didSelectEmptyCell isEmpty: Bool = false) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.moduleStyleCollectionView.alpha = isEmpty ? 0.55 :  1
            self?.moduleStyleCollectionView.isUserInteractionEnabled = isEmpty ? false : true
            
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
}

extension WidgetEditorView {
    private func createCompositionalLayout(
        for strategy: WidgetTypeStrategy = MainWidgetStrategy()
    ) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupHeight = strategy.type == .main ? 0.49 : 0.98
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(groupHeight)
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
