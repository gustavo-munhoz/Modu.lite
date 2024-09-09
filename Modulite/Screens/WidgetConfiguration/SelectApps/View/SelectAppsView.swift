//
//  SelectAppsView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit
import SnapKit

class SelectAppsView: UIView {
    
    // MARK: - Properties
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = CustomizedTextFactory.createTextWithAsterisk(
            with: .localized(for: .selectAppsViewTitle)
        )
        
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(for: .selectAppsViewSubtitle)
        label.textColor = .charcoalGray
        label.font = UIFont(textStyle: .footnote, symbolicTraits: .traitItalic)
        
        return label
    }()
    
    private(set) lazy var appsSelectedLabel: PaddedLabel = {
        let label = PaddedLabel()
                
        label.text = .localized(for: .selectAppsViewAppsSelected(count: 0))
        label.font = UIFont(textStyle: .callout, weight: .bold)
        label.textAlignment = .center
        label.edgeInsets = UIEdgeInsets(vertical: 4, horizontal: 10)
                
        label.layer.borderColor = UIColor.lemonYellow.cgColor
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 2
        
        return label
    }()
    
    private(set) lazy var appsSearchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = .localized(for: .selectAppsViewSearchBarPlaceholder)
        
        view.searchTextField.backgroundColor = .clear
        view.backgroundColor = .clear
        view.barTintColor = .clear
        view.backgroundImage = UIImage()
        
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        
        view.setImage(
            UIImage(systemName: "magnifyingglass")!.withTintColor(
                .fiestaGreen,
                renderingMode: .alwaysOriginal
            ),
            for: .search,
            state: .normal
        )
        
        return view
    }()
    
    private(set) lazy var appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 52, height: 32)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteTurnip
        addSubviews()
        setupConstraints()
        setupCollectionView()
        setupTapGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    func setSearchBarDelegate(to delegate: UISearchBarDelegate) {
        appsSearchBar.delegate = delegate
    }
    
    func setCollectionViewDelegate(to delegate: UICollectionViewDelegate) {
        appsCollectionView.delegate = delegate
    }
    
    func setCollectionViewDataSource(to dataSource: UICollectionViewDataSource) {
        appsCollectionView.dataSource = dataSource
    }
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissiveTap))
        addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    private func setupCollectionView() {
        appsCollectionView.register(
            AppCollectionViewCell.self,
            forCellWithReuseIdentifier: AppCollectionViewCell.reuseId
        )
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(appsSelectedLabel)
        addSubview(appsSearchBar)
        addSubview(appsCollectionView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(26)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        appsSelectedLabel.snp.makeConstraints { make in
            make.left.equalTo(subtitleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
        }
        
        appsSearchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(subtitleLabel)
            make.top.equalTo(appsSelectedLabel.snp.bottom).offset(12)
            make.height.equalTo(35)
        }
        
        appsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(appsSearchBar.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(subtitleLabel)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleDismissiveTap() {
        endEditing(true)
    }
    
    func updateAppCountText(to count: Int) {
        appsSelectedLabel.text = .localized(for: .selectAppsViewAppsSelected(count: count))
    }
}
