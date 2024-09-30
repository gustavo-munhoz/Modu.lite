//
//  SelectedAppCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 16/08/24.
//

import UIKit
import SnapKit

protocol SelectedAppCollectionViewCellDelegate: AnyObject {
    func selectedAppCollectionViewCellDidPressDelete(_ cell: SelectedAppCollectionViewCell)
}

class SelectedAppCollectionViewCell: UICollectionViewCell {
    static let reuseId = "SelectedAppCollectionViewCell"
    
    // MARK: - Properties
    
    weak var delegate: SelectedAppCollectionViewCellDelegate?
    
    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(textStyle: .title3, weight: .semibold)
        
        return view
    }()
    
    private(set) lazy var removeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: "xmark")?.withTintColor(
            .carrotOrange,
            renderingMode: .alwaysOriginal
        )
        
        config.preferredSymbolConfigurationForImage = .init(
            pointSize: 10,
            weight: .semibold
        )
        
        let view = UIButton(configuration: config)
        view.addTarget(self, action: #selector(handleDeleteTouch), for: .touchUpInside)
        
        view.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.1) {
                var config = button.configuration
                
                switch button.state {
                case .highlighted:
                    self.animateBorderColor(toColor: .red, duration: 0.25)
                    button.alpha = 0.5
                    self.transform = .init(scaleX: 0.97, y: 0.97)
                    
                default:
                    self.animateBorderColor(toColor: .carrotOrange, duration: 0.25)
                    button.alpha = 1
                    self.transform = .init(scaleX: 1, y: 1)
                }
            }
        }
        
        return view
    }()
        
    // MARK: - Setup methods
    
    func setup(with name: String) {
        subviews.forEach { $0.removeFromSuperview() }
        
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.carrotOrange.cgColor
        
        self.nameLabel.text = name
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(nameLabel)
        addSubview(removeButton)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(12)
            
        }
        
        removeButton.snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func handleDeleteTouch() {
        delegate?.selectedAppCollectionViewCellDidPressDelete(self)
    }
}
