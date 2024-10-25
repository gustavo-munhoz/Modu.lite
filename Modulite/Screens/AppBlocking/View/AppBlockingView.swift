//
//  AppBlockingView.swift
//  Modulite
//
//  Created by André Wozniack on 21/10/24.
//

import UIKit
import SnapKit

class AppBlockingView: UIView {
    
    // MARK: - Subviews
    private(set) lazy var sessionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 16, left: 0, bottom: 24, right: 0)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        
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
    
    // MARK: - Setup Methods
    func setCollectionViewDataSource(to dataSource: UICollectionViewDataSource) {
        sessionsCollectionView.dataSource = dataSource
    }
    
    func setCollectionViewDelegate(to delegate: UICollectionViewDelegate) {
        sessionsCollectionView.delegate = delegate
    }
    
    private func setupCollectionView() {
        sessionsCollectionView.register(
            AppBlockingSessionCell.self,
            forCellWithReuseIdentifier: AppBlockingSessionCell.reuseId
        )
        
        sessionsCollectionView.register(
            AppBlockingSessionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AppBlockingSessionHeader.reuseId
        )
    }
    
    private func addSubviews() {
        addSubview(sessionsCollectionView)
    }
    
    private func setupConstraints() {
        sessionsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.left.right.bottom.equalToSuperview().inset(24)
        }
    }
}
