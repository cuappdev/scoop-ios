//
//  LabeledTextView.swift
//  Scoop
//
//  Created by Richie Sun on 10/18/23.
//

import UIKit

class LabeledTextView: UIView {

    weak var delegate: UITextViewDelegate?

    // MARK: - Views

    private let nameLabel = UILabel()
    let textView = PaddedTextView()

    // MARK: - Setup Views

    func setup(title: String, placeholder: String? = nil) {
        var text = title
        if let placeholder = placeholder {
            text = placeholder
        }

        setupTextField(placeholder: text)
        setupLabel(title: title)
    }

    private func setupTextField(placeholder: String) {
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        textView.layer.borderColor = UIColor.black.cgColor
        textView.delegate = self.delegate
        textView.isUserInteractionEnabled = true
        textView.isSelectable = true
        textView.associatedView = self
        addSubview(textView)

        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupLabel(title: String) {
        nameLabel.text = " \(title) "
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.scooped.mutedGrey
        nameLabel.backgroundColor = .white
        nameLabel.isHidden = true
        addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(textView.snp.top)
        }
    }

    // MARK: - Helper Functions

    func labeledTextView(isSelected: Bool) {
        if isSelected {
            nameLabel.textColor = UIColor.scooped.scoopDarkGreen
            textView.layer.borderWidth = 2
            textView.layer.borderColor = UIColor.scooped.scoopDarkGreen.cgColor
        } else {
            nameLabel.textColor = UIColor.scooped.mutedGrey
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.black.cgColor
        }
    }

    func hidesLabel(isHidden: Bool) {
        nameLabel.isHidden = isHidden
    }

    func setText(str: String?) {
        textView.text = str
    }

    func getText() -> String? {
        return textView.text
    }

}

