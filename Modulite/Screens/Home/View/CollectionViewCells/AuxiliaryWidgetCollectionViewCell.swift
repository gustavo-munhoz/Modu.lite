//
//  AuxiliaryWidgetCollectionViewCell.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 13/08/24.
//

import UIKit
import SnapKit

class AuxiliaryWidgetCollectionViewCell: UICollectionViewCell {
    static let reuseId = "AuxiliaryWidgetCollectionViewCell"

    // UIImageView para exibir a imagem
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configura a UIImageView dentro da célula
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // Método público para configurar a célula com uma imagem
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
