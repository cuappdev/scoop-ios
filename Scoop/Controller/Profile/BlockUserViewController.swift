//
//  BlockUserViewController.swift
//  Scoop
//
//  Created by Richie Sun on 10/18/23.
//

import UIKit

class BlockUserViewController: ModalViewController {
    
    // MARK: - Views

    private let blockButton = UIButton()
    private let blockedLabel = UILabel()
    private let cancelButton = UIButton()
    private let interactLabel = UILabel()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let unblockLabel = UILabel()

    private let blockCallImageView = UIImageView(image: UIImage.scooped.blockCallIcon)
    private let cancelImageView = UIImageView(image: UIImage.scooped.cancelIcon)
    private let settingsImageView = UIImageView(image: UIImage.scooped.setttingsIcon)

    // MARK: - User Data

    let user: BaseUser

    // MARK: - Initializers

    init(user: BaseUser, height: CGFloat) {
        self.user = user
        super.init(height: height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupModalTab()
        setupStackViewContents()
        setupStackView()
        setupButtons()
    }

    // MARK: - Setup Views

    private func setupStackViewContents() {
        titleLabel.text = "Block \(user.firstName) \(user.lastName)?"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.axis = .vertical

        [cancelImageView, blockCallImageView, settingsImageView].forEach { icon in
            icon.contentMode = .scaleAspectFit

            icon.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
        }

        [blockedLabel, interactLabel, unblockLabel].forEach { label in
            label.textColor = .black
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.numberOfLines = 2
        }
    }

    private func setupStackView() {
        let blockedView = UIView()

        blockedView.addSubview(cancelImageView)

        cancelImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        blockedLabel.text = "They will not be notified that you have blocked them."
        blockedView.addSubview(blockedLabel)

        blockedLabel.snp.makeConstraints { make in
            make.leading.equalTo(cancelImageView.snp.trailing).offset(28)
            make.top.bottom.trailing.equalToSuperview()
        }

        stackView.addArrangedSubview(blockedView)

        blockedView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        let interactView = UIView()

        interactView.addSubview(blockCallImageView)

        blockCallImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        interactLabel.text = "They will not be able to interact with you on this platform."
        interactView.addSubview(interactLabel)

        interactLabel.snp.makeConstraints { make in
            make.leading.equalTo(blockCallImageView.snp.trailing).offset(28)
            make.top.bottom.trailing.equalToSuperview()
        }

        stackView.addArrangedSubview(interactView)

        interactView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        let unblockView = UIView()

        unblockView.addSubview(settingsImageView)

        settingsImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        unblockLabel.text = "You can unblock this user in settings."
        unblockView.addSubview(unblockLabel)

        unblockLabel.snp.makeConstraints { make in
            make.leading.equalTo(settingsImageView.snp.trailing).offset(28)
            make.top.bottom.trailing.equalToSuperview()
        }

        stackView.addArrangedSubview(unblockView)

        unblockView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(48)
        }
    }

    private func setupButtons() {
        let buttonView = UIView()
        
        [cancelButton, blockButton].forEach { button in
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 25
            buttonView.addSubview(button)

            button.snp.makeConstraints { make in
                make.width.equalTo(120)
                make.height.equalTo(50)
                make.top.bottom.equalToSuperview()
            }
        }

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .systemGray4
        cancelButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)

        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }

        blockButton.setTitle("Block", for: .normal)
        blockButton.backgroundColor = UIColor.scooped.secondaryGreen
        blockButton.addTarget(self, action: #selector(blockUser), for: .touchUpInside)

        blockButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }

        contentView.addSubview(buttonView)

        buttonView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(36)
            make.leading.trailing.equalTo(stackView)
        }
    }

    // MARK: - Helper Functions

    @objc private func blockUser() {
        // TODO: Call Block Backend Route HERE
    }
    
}
