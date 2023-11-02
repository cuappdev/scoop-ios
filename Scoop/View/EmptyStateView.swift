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

    private let mainView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subLabel = UILabel()

    // MARK: - Set Up Views

    func setup(image: UIImage, title: String, subtitle: String) {
        imageView.image = image
        titleLabel.text = title
        subLabel.text = subtitle

        setupMainView()
        setupImageView()
        setupTitleLabel()
        setupSubLabel()
    }

    private func setupMainView() {
        addSubview(mainView)

        mainView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-64)
        }
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        mainView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.scooped.bodySemibold
        titleLabel.textColor = UIColor.black
        mainView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(24)
        }
    }

    private func setupSubLabel() {
        subLabel.font = UIFont.scooped.bodyNormal
        subLabel.textColor = UIColor.secondaryLabel
        mainView.addSubview(subLabel)

        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }

}
