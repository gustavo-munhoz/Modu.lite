//
//  TutorialCenterView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit
import SnapKit

class TutorialCenterView: UIScrollView {
    
    // MARK: - Properties
    var onCreateWidgetButtonTapped: (() -> Void)?
    var onCreateWidgetVideoButtonTapped: (() -> Void)?
    var onEditOrDeleteWidgetButtonTapped: (() -> Void)?
    
    var onAddWidgetButtonTapped: (() -> Void)?
    var onAddWidgetVideoButtonTapped: (() -> Void)?
    
    var onSetWallpaperButtonTapped: (() -> Void)?
    var onChangeWallpaperVideoButtonTapped: (() -> Void)?
    
    private let contentView = UIView()
    
    private let moduliteSectionTitle = TutorialCenterSmallTitle(
        localizedKey: .tutorialCenterModuliteTitle
    )
    
    private(set) lazy var createWidgetButton: TutorialCenterOptionButton = {
        let view = TutorialCenterOptionButton(
            textLocalizedKey: .tutorialCenterHowToCreateWidget
        )
        view.addTarget(self, action: #selector(didPressCreateWidgetButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var createWidgetVideoButton: TutorialCenterOptionButton = {
        let view = TutorialCenterOptionButton(
            textLocalizedKey: .tutorialCenterHowToCreateWidgetVideo,
            hasVideoIcon: true
        )
        view.addTarget(self, action: #selector(didPressCreateWidgetVideoButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var editOrDeleteWidgetButton: TutorialCenterOptionButton = {
        let view = TutorialCenterOptionButton(
            textLocalizedKey: .tutorialCenterHowToEditOrDeleteWidget
        )
        view.addTarget(self, action: #selector(didPressEditOrDeleteWidgetButton), for: .touchUpInside)
        
        return view
    }()
    
    private let widgetSectionTitle = TutorialCenterSmallTitle(
        localizedKey: .tutorialCenterWidgetsTitle
    )
    
    private(set) lazy var addWidgetsButton: TutorialCenterOptionButton = {
        let view = TutorialCenterOptionButton(
            textLocalizedKey: .tutorialCenterAddWidgetsToHomeScreen
        )
        view.addTarget(self, action: #selector(didPressAddWidgetButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var addWidgetsVideoButton: TutorialCenterOptionButton = {
        let view = TutorialCenterOptionButton(
            textLocalizedKey: .tutorialCenterAddWidgetsToHomeScreenVideo,
            hasVideoIcon: true
        )
        view.addTarget(self, action: #selector(didPressAddWidgetVideoButton), for: .touchUpInside)
        
        return view
    }()
    
    private let wallpaperSectionTitle = TutorialCenterSmallTitle(
        localizedKey: .tutorialCenterWallpapersTitle
    )
    
    private(set) lazy var setWallpapersButton: TutorialCenterOptionButton = {
        let view = TutorialCenterOptionButton(textLocalizedKey: .tutorialCenterSetWallpapers)
        view.addTarget(self, action: #selector(didPressSetWallpapersButton), for: .touchUpInside)
        
        return view
    }()
    
    private(set) lazy var setWallpapersVideoButton: TutorialCenterOptionButton = {
        let view = TutorialCenterOptionButton(
            textLocalizedKey: .tutorialCenterChangeWallpaperVideo,
            hasVideoIcon: true
        )
        view.addTarget(self, action: #selector(didPressChangeWallpaperButton), for: .touchUpInside)
        
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setupModuliteSection()
        setupWidgetsSection()
        setupWallpapersSection()
        
        backgroundColor = .whiteTurnip
        
        delaysContentTouches = false
        canCancelContentTouches = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func didPressCreateWidgetButton() {
        onCreateWidgetButtonTapped?()
    }
    
    @objc private func didPressCreateWidgetVideoButton() {
        onCreateWidgetVideoButtonTapped?()
    }
    
    @objc private func didPressEditOrDeleteWidgetButton() {
        onEditOrDeleteWidgetButtonTapped?()
    }
    
    @objc private func didPressAddWidgetButton() {
        onAddWidgetButtonTapped?()
    }
    
    @objc private func didPressAddWidgetVideoButton() {
        onAddWidgetVideoButtonTapped?()
    }
    
    @objc private func didPressSetWallpapersButton() {
        onSetWallpaperButtonTapped?()
    }
    
    @objc private func didPressChangeWallpaperButton() {
        onChangeWallpaperVideoButtonTapped?()
    }
    
    // MARK: - Setup Methods
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton { return true }
        return super.touchesShouldCancel(in: view)
    }
    
    private func setupScrollView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupModuliteSection() {
        contentView.addSubview(moduliteSectionTitle)
        contentView.addSubview(createWidgetButton)
        contentView.addSubview(createWidgetVideoButton)
        contentView.addSubview(editOrDeleteWidgetButton)
        
        moduliteSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.left.right.equalTo(contentView).inset(20)
        }
        
        createWidgetButton.snp.makeConstraints { make in
            make.top.equalTo(moduliteSectionTitle.snp.bottom)
            make.height.equalTo(50)
            make.left.right.equalTo(moduliteSectionTitle)
        }
        
        createWidgetVideoButton.snp.makeConstraints { make in
            make.top.equalTo(createWidgetButton.snp.bottom)
            make.height.greaterThanOrEqualTo(64)
            make.left.right.equalTo(createWidgetButton)
        }
        
        editOrDeleteWidgetButton.snp.makeConstraints { make in
            make.top.equalTo(createWidgetVideoButton.snp.bottom)
            make.height.greaterThanOrEqualTo(64)
            make.left.right.equalTo(createWidgetVideoButton)
        }
    }
    
    private func setupWidgetsSection() {
        contentView.addSubview(widgetSectionTitle)
        contentView.addSubview(addWidgetsButton)
        contentView.addSubview(addWidgetsVideoButton)
        
        widgetSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(editOrDeleteWidgetButton.snp.bottom).offset(24)
            make.left.right.equalTo(contentView).inset(20)
        }
        
        addWidgetsButton.snp.makeConstraints { make in
            make.top.equalTo(widgetSectionTitle.snp.bottom)
            make.height.equalTo(50)
            make.left.right.equalTo(widgetSectionTitle)
        }
        
        addWidgetsVideoButton.snp.makeConstraints { make in
            make.top.equalTo(addWidgetsButton.snp.bottom)
            make.height.greaterThanOrEqualTo(64)
            make.left.right.equalTo(addWidgetsButton)
        }
    }

    private func setupWallpapersSection() {
        contentView.addSubview(wallpaperSectionTitle)
        contentView.addSubview(setWallpapersButton)
        contentView.addSubview(setWallpapersVideoButton)
        
        wallpaperSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(addWidgetsVideoButton.snp.bottom).offset(24)
            make.left.right.equalTo(contentView).inset(20)
        }
        
        setWallpapersButton.snp.makeConstraints { make in
            make.top.equalTo(wallpaperSectionTitle.snp.bottom)
            make.height.equalTo(50)
            make.left.right.equalTo(wallpaperSectionTitle)
        }
        
        setWallpapersVideoButton.snp.makeConstraints { make in
            make.top.equalTo(setWallpapersButton.snp.bottom)
            make.height.greaterThanOrEqualTo(64)
            make.left.right.equalTo(setWallpapersButton)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
}
