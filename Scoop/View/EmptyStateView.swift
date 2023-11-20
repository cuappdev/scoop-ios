//
//  EmptyStateView.swift
//  Scoop
//
//  Created by Caitlyn Jin on 10/28/23.
//

import Foundation
import UIKit

class EmptyStateView: UIView {

    // MARK: - Views

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let subLabel = UILabel()

    // MARK: - Set Up Views

    func setup(image: UIImage, title: String, subtitle: String) {
        imageView.image = image
        titleLabel.text = title
        subLabel.text = subtitle

        setupStackView()
        setupImageView()
        if !title.isEmpty { setupTitleLabel() }
        setupSubLabel()
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY).offset(-28)
        }
    }

    private func setupImageView() {
        stackView.setCustomSpacing(24, after: imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        stackView.addArrangedSubview(imageView)
        stackView.setCustomSpacing(24, after: imageView)

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.scooped.bodySemibold
        titleLabel.textColor = UIColor.black
        stackView.addArrangedSubview(titleLabel)
    }

    private func setupSubLabel() {
        subLabel.font = UIFont.scooped.bodyNormal
        subLabel.textColor = UIColor.secondaryLabel
        stackView.addArrangedSubview(subLabel)
    }

}
