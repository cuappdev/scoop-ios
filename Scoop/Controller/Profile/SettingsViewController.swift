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
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func setupSettingsCells() {
        blockedView.setup(icon: UIImage.scooped.blockIcon!, text: "Blocked users")
        reportView.setup(icon: UIImage.scooped.reportIcon!, text: "Report a problem")
        signoutView.setup(icon: UIImage.scooped.signoutIcon!, text: "Sign out")

        let views = [blockedView, reportView, signoutView]

        views.forEach { view in
            stackView.addArrangedSubview(view)

            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(52)
            }
        }
    }

}
