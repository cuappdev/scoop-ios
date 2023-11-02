//
//  ReportUserViewController.swift
//  Scoop
//
//  Created by Richie Sun on 10/18/23.
//

import UIKit

class ReportUserViewController: ModalViewController {

    // MARK: - Views

    private let cancelButton = UIButton()
    private let messageLabel = UILabel()
    private let reportButton = UIButton()
    private let responseTextView = LabeledTextView()
    private let titleLabel = UILabel()

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
        setupTitle()
        setupTextView()
        setupButtons()
    }

    // MARK: - Setup Views

    private func setupTitle() {
        titleLabel.text = "Report \(user.firstName) \(user.lastName)?"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        messageLabel.text = "Your feedback is valuable to Scooped. Thank you for helping make the Cornell community a safer place. We will review your report and get back to you as soon as we can."
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        contentView.addSubview(messageLabel)

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }

    private func setupTextView() {
        responseTextView.delegate = self
        responseTextView.setup(title: "Details")
        responseTextView.hidesLabel(isHidden: false)
        contentView.addSubview(responseTextView)

        responseTextView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(124)
        }
    }

    private func setupButtons() {
        let buttonView = UIView()
        
        [cancelButton, reportButton].forEach { button in
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

        reportButton.setTitle("Report", for: .normal)
        reportButton.backgroundColor = UIColor.scooped.secondaryGreen
        reportButton.addTarget(self, action: #selector(reportUser), for: .touchUpInside)

        reportButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }

        contentView.addSubview(buttonView)

        buttonView.snp.makeConstraints { make in
            make.top.equalTo(responseTextView.snp.bottom).offset(32)
            make.leading.trailing.equalTo(responseTextView)
        }
    }

    // MARK: - Helper Functions

    @objc private func reportUser() {
        // TODO: Call Report Backend Route HERE
    }

}


// MARK: - UITextViewDelegate

extension ReportUserViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if let paddedTextView = textView as? PaddedTextView,
           let associatedView = paddedTextView.associatedView as? LabeledTextView {
            associatedView.labeledTextView(isSelected: true)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let paddedTextView = textView as? PaddedTextView,
           let associatedView = paddedTextView.associatedView as? LabeledTextView {
            associatedView.labeledTextView(isSelected: false)
        }
    }

}
