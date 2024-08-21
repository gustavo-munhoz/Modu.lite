//
//  WidgetEditorView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 14/08/24.
//

import UIKit

class WidgetEditorView: UIScrollView {
    
    // MARK: - Properties
    
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
        
        return view
    }()
    
    private(set) lazy var moduleStyleHeader: UILabel = {
        let view = UILabel()
        view.text = .localized(for: .widgetEditorViewWidgetModuleTitle)
        view.font = UIFont(textStyle: .body, symbolicTraits: .traitBold.union(.traitItalic))
        
        return view
    }()
    
    private(set) lazy var moduleStyleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .potatoYellow
        
        return view
    }()
    
    private(set) lazy var wallpaperHeader: EditorSectionHeader = {
        let view = EditorSectionHeader()
        view.setTitleForKey(.widgetEditorViewWidgetWallpaperTitle)
        
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
    
    func setLayoutCollectionViewDelegate(
        to delegate: UICollectionViewDelegate & UICollectionViewDragDelegate & UICollectionViewDropDelegate
    ) {
        widgetLayoutCollectionView.delegate = delegate
        widgetLayoutCollectionView.dragDelegate = delegate
        widgetLayoutCollectionView.dropDelegate = delegate
    }
    
    func setLayoutCollectionViewDataSource(to dataSource: UICollectionViewDataSource) {
        widgetLayoutCollectionView.dataSource = dataSource
    }
    
    func setLayoutHeaderInfoAction(_ action: @escaping () -> Void) {
        layoutHeader.onInfoButtonPressed = action
    }
    
    private func setupCollectionViews() {
        widgetLayoutCollectionView.register(
            WidgetLayoutCell.self,
            forCellWithReuseIdentifier: WidgetLayoutCell.reuseId
        )
    }
    
    private func addSubviews() {
        addSubview(contentView)
        contentView.addSubview(layoutHeader)
        contentView.addSubview(widgetLayoutCollectionView)
        contentView.addSubview(moduleStyleHeader)
        contentView.addSubview(moduleStyleCollectionView)
        contentView.addSubview(wallpaperHeader)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 24, left: 24, bottom: 0, right: -24))
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
            make.left.right.equalToSuperview()
        }
        
        wallpaperHeader.snp.makeConstraints { make in
            make.top.equalTo(moduleStyleCollectionView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
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
                heightDimension: .fractionalHeight(0.5)
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
