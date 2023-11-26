//
//  BlockedUserTableViewCell.swift
//  Scoop
//
//  Created by Caitlyn Jin on 11/12/23.
//

import UIKit

class BlockedUserTableViewCell: UITableViewCell {

    // MARK: - Views

    private let profileImageView = UIImageView()
    private let userLabel = UILabel()
    private let unblockButton = UIButton()

    static let reuse = "BlockedUserCellReuse"
    weak var delegate: BlockedUsersDelegate?

    // MARK: - User Data

    private var user: BaseUser?

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        setupProfileImageView()
        setupUserLabel()
        setupUnblockButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(user: BaseUser, delegate: BlockedUsersDelegate) {
        self.user = user
        profileImageView.sd_setImage(with: URL(string: user.profilePicUrl ?? ""), placeholderImage: UIImage.scooped.emptyImage)
        userLabel.text = "\(user.firstName) \(user.lastName)"
        self.delegate = delegate
    }

    // MARK: Setup View Functions

    private func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 48 / 2
        contentView.addSubview(profileImageView)

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(48)
        }
    }

    private func setupUserLabel() {
        userLabel.font = UIFont.scooped.bodyNormal
        userLabel.textColor = UIColor.black
        contentView.addSubview(userLabel)

        userLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(profileImageView)
        }
    }

    private func setupUnblockButton() {
        unblockButton.setTitle("Unblock", for: .normal)
        unblockButton.titleLabel?.font = UIFont.scooped.buttonSemibold
        unblockButton.setTitleColor(UIColor.black, for: .normal)
        unblockButton.backgroundColor = UIColor.scooped.secondaryGreen
        unblockButton.layer.borderColor = UIColor.scooped.secondaryGreen.cgColor
        unblockButton.layer.borderWidth = 1
        unblockButton.layer.masksToBounds = true
        unblockButton.layer.cornerRadius = 15
        contentView.addSubview(unblockButton)

        unblockButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)

        unblockButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(74)
            make.centerY.equalTo(profileImageView)
        }
    }

    // MARK: - Helper Functions

    @objc private func tapButton() {
        if unblockButton.titleLabel?.text == "Unblock" {
            let popUpVC = PopUpViewController()

            let attributedTitle = NSMutableAttributedString(
                string: "Are you sure you want to unblock \(user?.firstName ?? "") \(user?.lastName ?? "")?",
                attributes: [NSAttributedString.Key.font: UIFont.scooped.bodyNormal]
            )
            let range = attributedTitle.mutableString.range(of: "\(user?.firstName ?? "") \(user?.lastName ?? "")")
            attributedTitle.addAttributes([NSAttributedString.Key.font: UIFont.scooped.bodyBold], range: range)

            popUpVC.configure(
                title: attributedTitle,
                subtitle: "",
                actionButtonText: "Unblock",
                delegate: self
            )

            delegate?.presentPopUp(popUpVC: popUpVC)
        } else {
            unblockButton.setTitle("Unblock", for: .normal)
            unblockButton.backgroundColor = UIColor.scooped.secondaryGreen
            unblockButton.layer.borderColor = UIColor.scooped.secondaryGreen.cgColor

            if let user = user {
                delegate?.updateBlockedUsers(user: user, isBlocked: true)
            }
        }
    }

}

extension BlockedUserTableViewCell: PopUpViewDelegate {

    func acceptPopUp() {
        if let user = user {
            delegate?.updateBlockedUsers(user: user, isBlocked: false)
        }

        unblockButton.setTitle("Block", for: .normal)
        unblockButton.backgroundColor = UIColor.white
        unblockButton.layer.borderColor = UIColor.black.cgColor
    }

}

