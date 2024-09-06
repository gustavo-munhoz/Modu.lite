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
        
        // TODO: Pass count through controller
        label.text = .localized(for: .selectAppsViewAppsSelected(count: 0))
        label.font = UIFont(textStyle: .callout, weight: .bold)
        label.textAlignment = .center
        label.edgeInsets = UIEdgeInsets(vertical: 4, horizontal: 10)
                
        label.layer.borderColor = UIColor.lemonYellow.cgColor
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 2
        
        return label
    }()
    
    private(set) lazy var appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width - 32, height: 32)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteTurnip
        addSubviews()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
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
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
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
    }
}
