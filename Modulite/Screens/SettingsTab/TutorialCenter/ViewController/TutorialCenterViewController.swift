//
//  TutorialCenterViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 08/10/24.
//

import UIKit

protocol TutorialCenterViewControllerDelegate: AnyObject {
    func tutorialCenterDidPressCreateWidget(_ viewController: TutorialCenterViewController)
    func tutorialCenterDidPressCreateWidgetVideo(_ viewController: TutorialCenterViewController)
    func tutorialCenterDidPressEditOrDeleteWidget(_ viewController: TutorialCenterViewController)
    func tutorialCenterDidPressAddWidget(_ viewController: TutorialCenterViewController)
    func tutorialCenterDidPressAddWidgetVideo(_ viewController: TutorialCenterViewController)
    func tutorialCenterDidPressSetWallpaper(_ viewController: TutorialCenterViewController)
    func tutorialCenterDidPressChangeWallpaperVideo(_ viewController: TutorialCenterViewController)
}

class TutorialCenterViewController: UIViewController {
    
    // MARK: - Properties
    private let tutorialCenterView = TutorialCenterView()
    
    weak var delegate: TutorialCenterViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = tutorialCenterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationItem.title = .localized(for: SettingsLocalizedTexts.settingsViewTutorialsTitle)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViewActions() {
        tutorialCenterView.onCreateWidgetButtonTapped = didPressCreateWidget
        tutorialCenterView.onCreateWidgetVideoButtonTapped = didPressCreateWidgetVideo
        tutorialCenterView.onEditOrDeleteWidgetButtonTapped = didPressEditOrDeleteWidget
        tutorialCenterView.onAddWidgetButtonTapped = didPressAddWidget
        tutorialCenterView.onAddWidgetVideoButtonTapped = didPressAddWidgetVideo
        tutorialCenterView.onSetWallpaperButtonTapped = didPressSetWallpaper
        tutorialCenterView.onChangeWallpaperVideoButtonTapped = didPressChangeWallpaperVideo
    }
    
    // MARK: - Actions
    private func didPressCreateWidget() {
        delegate?.tutorialCenterDidPressCreateWidget(self)
    }
    
    private func didPressCreateWidgetVideo() {
        delegate?.tutorialCenterDidPressAddWidgetVideo(self)
    }
    
    private func didPressEditOrDeleteWidget() {
        delegate?.tutorialCenterDidPressEditOrDeleteWidget(self)
    }

    private func didPressAddWidget() {
        delegate?.tutorialCenterDidPressAddWidget(self)
    }

    private func didPressAddWidgetVideo() {
        delegate?.tutorialCenterDidPressAddWidgetVideo(self)
    }

    private func didPressSetWallpaper() {
        delegate?.tutorialCenterDidPressSetWallpaper(self)
    }

    private func didPressChangeWallpaperVideo() {
        delegate?.tutorialCenterDidPressChangeWallpaperVideo(self)
    }
}

extension TutorialCenterViewController {
    static func instantiate(delegate: TutorialCenterViewControllerDelegate) -> Self {
        let viewController = Self()
        viewController.delegate = delegate
        
        return viewController
    }
}
