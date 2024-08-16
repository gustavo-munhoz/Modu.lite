//
//  SelectedAppCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 16/08/24.
//

import UIKit
import SnapKit

class SelectedAppCollectionViewCell: UICollectionViewCell {
    static let reuseId = "SelectedAppCollectionViewCell"
    
    // MARK: - Properties
    
    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.text = "testeeeee"
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods

    func addSubviews() {
        addSubview(nameLabel)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
