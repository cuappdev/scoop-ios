//
//  SettingsCellView.swift
//  Scoop
//
//  Created by Caitlyn Jin on 11/8/23.
//

import UIKit

class SettingsCellView: UIView {

    // MARK: - Views

    private let iconImageView = UIImageView()
    private let textLabel = UILabel()

    // MARK: - Set Up Views

    func setup(icon: UIImage, text: String) {
        iconImageView.image = icon
        textLabel.text = text

        setupIconImageView()
        setupTextLabel()
    }

    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTextLabel() {
        textLabel.font = UIFont.scooped.bodyMedium
        textLabel.textColor = UIColor.black
        addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
