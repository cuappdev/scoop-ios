//
//  SettingsViewController.swift
//  Scoop
//
//  Created by Caitlyn Jin on 11/7/23.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Views

    private let blockedImageView = UIImageView()
    private let blockedLabel = UILabel()
    private let reportImageView = UIImageView()
    private let reportLabel = UILabel()
    private let signoutImageView = UIImageView()
    private let signoutLabel = UILabel()

    private let blockedView = SettingsCellView()
    private let reportView = SettingsCellView()
    private let signoutView = SettingsCellView()

    private let stackView = UIStackView()

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        setupHeader()
        setupStackView()
        setupSettingsCells()
    }

    // MARK: - Setup View Functions

    private func setupHeader() {
        let dottedLineMultiplier = 0.52
        let solidLineVerticalInset = -12.75
        let solidLineMultiplier = 0.32
        let screenSize = UIScreen.main.bounds
        let dottedline = UIImageView(image: UIImage.scooped.dottedLine)
        let solidline = UIView()

        dottedline.contentMode = .scaleAspectFit
        view.addSubview(dottedline)

        dottedline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width * dottedLineMultiplier)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        solidline.backgroundColor = UIColor.black
        view.addSubview(solidline)

        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width * solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.scooped.flowHeader]
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.distribution = .fill
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func setupSettingsCells() {
        let line1 = UIImageView()
        let line2 = UIImageView()

        let lineBreaks = [line1, line2]
        lineBreaks.forEach { line in
            line.image = UIImage.scooped.lineBreak
            line.contentMode = .scaleAspectFit

            line.snp.makeConstraints { make in
                make.height.equalTo(4)
            }
        }

        let blockedTap = UITapGestureRecognizer(target: self, action: #selector(pushBlockedUsersVC))
        blockedView.addGestureRecognizer(blockedTap)
        blockedView.setup(icon: UIImage.scooped.blockIcon!, text: "Blocked users")
        stackView.addArrangedSubview(blockedView)

        stackView.addArrangedSubview(line1)

        let reportTap = UITapGestureRecognizer(target: self, action: #selector(pushReportProblemVC))
        reportView.addGestureRecognizer(reportTap)
        reportView.setup(icon: UIImage.scooped.reportIcon!, text: "Report a problem")
        stackView.addArrangedSubview(reportView)

        stackView.addArrangedSubview(line2)

        let signoutTap = UITapGestureRecognizer(target: self, action: #selector(signout))
        signoutView.addGestureRecognizer(signoutTap)
        signoutView.setup(icon: UIImage.scooped.signoutIcon!, text: "Sign out")
        stackView.addArrangedSubview(signoutView)

        let cells = [blockedView, reportView, signoutView]
        cells.forEach { cell in
            cell.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(52)
            }
        }
    }

    // MARK: - Helper Functions

    @objc private func pushBlockedUsersVC() {
        let blockedUsersVC = BlockedUsersViewController()
        navigationController?.pushViewController(blockedUsersVC, animated: true)
    }

    @objc private func pushReportProblemVC() {
        // TODO: Push report problem VC
    }

    @objc private func signout() {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true
        loginVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(loginVC, animated: false)
    }

}
