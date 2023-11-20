//
//  PopUpView.swift
//  Scoop
//
//  Created by Caitlyn Jin on 11/15/23.
//

import UIKit

class PopUpViewController: UIViewController {

    // MARK: - Views

    private let blurEffectView = UIVisualEffectView()
    private let cancelButton = UIButton()
    private let containerView = UIView()
    private let actionButton = UIButton()
    private let stackView = UIStackView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()

    weak var delegate: PopUpViewDelegate?

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBlurEffectView()
        setupContainerView()
        setupStackView()
    }

    // MARK: - Initializers

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: NSMutableAttributedString, subtitle: String, actionButtonText: String, delegate: PopUpViewDelegate) {
        titleLabel.attributedText = title
        subtitleLabel.text = subtitle
        actionButton.setAttributedTitle(NSMutableAttributedString(string: actionButtonText, attributes: [NSAttributedString.Key.font: UIFont.scooped.bodyBold]), for: .normal)
        self.delegate = delegate

        setupTitle()
        if !subtitle.isEmpty {
            setupSubtitle()
        }
        setupActionButton()
        setupCancelButton()
    }

    // MARK: - Setup View Functions

    private func setupBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView.effect = blurEffect
        blurEffectView.layer.opacity = 0.4
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }

    private func setupContainerView() {
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 16
        view.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(276)
        }
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.alignment = .center
        stackView.distribution = .fill
        containerView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(24)
        }
    }

    private func setupTitle() {
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(titleLabel)
    }

    private func setupSubtitle() {
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor.scooped.mutedGrey
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textAlignment = .center
        stackView.addArrangedSubview(subtitleLabel)
    }

    private func setupActionButton() {
        actionButton.backgroundColor = UIColor.scooped.scoopGreen
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.layer.cornerRadius = 36 / 2
        stackView.addArrangedSubview(actionButton)

        actionButton.addTarget(self, action: #selector(doAction), for: .touchUpInside)

        actionButton.snp.makeConstraints { make in
            make.width.equalTo(162)
            make.height.equalTo(36)
        }
    }

    private func setupCancelButton() {
        stackView.setCustomSpacing(8, after: actionButton)
        cancelButton.setAttributedTitle(NSMutableAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)]), for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        stackView.addArrangedSubview(cancelButton)

        cancelButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)

        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(162)
            make.height.equalTo(36)
        }
    }

    // MARK: - Helper Functions

    @objc private func doAction() {
        dismiss(animated: true)
        delegate?.acceptPopUp()
    }

    @objc private func popVC() {
        dismiss(animated: true)
    }

}

protocol PopUpViewDelegate: AnyObject {
    func acceptPopUp()
}
