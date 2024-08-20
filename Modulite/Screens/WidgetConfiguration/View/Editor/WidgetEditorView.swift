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
        let layout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .red
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
            make.width.equalTo(338)
            make.height.equalTo(354)
        }
        
        moduleStyleHeader.snp.makeConstraints { make in
            make.top.equalTo(widgetLayoutCollectionView.snp.bottom).offset(24)
            make.width.equalToSuperview()
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
}
