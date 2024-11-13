//
//  HomeWidgetCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import SnapKit

protocol HomeWidgetCollectionViewCellDelegate: AnyObject {
    func homeWidgetCellDidRequestEdit(_ cell: HomeWidgetCollectionViewCell)
    func homeWidgetCellDidRequestDelete(_ cell: HomeWidgetCollectionViewCell)
}

class HomeWidgetCollectionViewCell: UICollectionViewCell {
    static let reuseId = "MainWidgetCollectionViewCell"
    
    weak var delegate: HomeWidgetCollectionViewCellDelegate?
    
    // MARK: - Properties
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    private(set) lazy var widgetImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        let interaction = UIContextMenuInteraction(delegate: self)
        view.addInteraction(interaction)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private(set) lazy var widgetNameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(textStyle: .callout, weight: .semibold)
        view.textColor = .systemGray
        view.textAlignment = .center
        
        return view
    }()
    
    var widgetName: String {
        widgetNameLabel.text!
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup methods
    func configure(image: UIImage?, name: String?) {
        widgetImageView.image = image
        widgetNameLabel.text = name
    }
    
    private func addSubviews() {
        addSubview(widgetImageView)
        addSubview(widgetNameLabel)
    }
    
    private func setupConstraints() {
        widgetImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().offset(-38)
        }
        
        widgetNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(widgetImageView.snp.bottom).offset(16)
        }
    }
}

extension HomeWidgetCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            configurationForMenuAtLocation location: CGPoint
        ) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: nil,
                actionProvider: { [weak self] _ in
                    guard let self = self else { return nil }
                    
                    return self.makeContextMenu()
                }
            )
        }
    
    func makeContextMenu() -> UIMenu {
        let editAction = UIAction(
            title: .localized(for: .homeViewWidgetContextMenuEditTitle),
            image: UIImage(systemName: "pencil")
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.homeWidgetCellDidRequestEdit(self)
        }
        
        let deleteAction = UIAction(
            title: .localized(for: .homeViewWidgetContextMenuDeleteTitle),
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.homeWidgetCellDidRequestDelete(self)
        }
        
        return UIMenu(title: widgetNameLabel.text!, children: [editAction, deleteAction])
    }
}
