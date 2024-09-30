//
//  AppUsageCell.swift
//  Modulite
//
//  Created by André Wozniack on 26/09/24.
//

import Foundation
import UIKit
import SnapKit

class AppUsageCell: UITableViewCell {
    static let identifier = "AppUsageCell"

    let appNameLabel = UILabel()
    let durationLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        appNameLabel.font = UIFont.systemFont(ofSize: 16)
        durationLabel.font = UIFont.systemFont(ofSize: 16)
        durationLabel.textAlignment = .right

        contentView.addSubview(appNameLabel)
        contentView.addSubview(durationLabel)

        appNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        durationLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
