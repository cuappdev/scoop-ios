//
//  ModalViewController.swift
//  Scoop
//
//  Created by Richie Sun on 10/18/23.
//

import UIKit

class ModalViewController: UIViewController {

    // MARK: - Views

    let contentView = UIView()

    // MARK: - Constants

    private let height: CGFloat

    // MARK: - Initializers

    init(height: CGFloat) {
        self.height = height
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentView()
    }

    // MARK: - Setup Views

    private func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }

    // MARK: - Helper Functions

    func setupModalTab() {
        let tabView = UIView()

        tabView.backgroundColor = .systemGray4
        tabView.layer.cornerRadius = 2
        contentView.addSubview(tabView)

        tabView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.width.equalTo(48)
            make.height.equalTo(4)
            make.centerX.equalToSuperview()
        }
    }

    @objc func dismissAction() {
        self.dismiss(animated: true)
    }

}
