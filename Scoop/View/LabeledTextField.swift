//
//  LabeledTextField.swift
//  Scoop
//
//  Created by Richie Sun on 9/27/23.
//

import UIKit

class LabeledTextField: UIView {
    
    weak var delegate: UITextFieldDelegate?
    
    // MARK: - Views

    let errorLabel = UILabel()
    private let nameLabel = UILabel()
    var textField = OnboardingTextField()

    // MARK: - Initializers

    init(isShifted: Bool = false) {
        if isShifted {
            textField = OnboardingTextField(isShifted: true)
        }

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views
    
    func setup(title: String, placeholder: String? = nil, error: String? = nil) {
        var text = title
        var errorText = "Please complete this field."
        if let placeholder = placeholder {
            text = placeholder
        }

        if let error = error {
            errorText = error
        }
        
        setupTextField(placeholder: text)
        setupLabels(title: title, error: errorText)
    }
    
    private func setupTextField(placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.scooped.mutedGrey.cgColor
        textField.delegate = self.delegate
        textField.isUserInteractionEnabled = true
        textField.associatedView = self
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
    }
    
    private func setupLabels(title: String, error: String) {
        nameLabel.text = " \(title) "
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.scooped.mutedGrey
        nameLabel.backgroundColor = .white
        nameLabel.isHidden = true
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(textField.snp.top)
        }

        errorLabel.text = error
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = UIColor.scooped.errorRed
        errorLabel.backgroundColor = .white
        errorLabel.isHidden = true
        addSubview(errorLabel)

        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helper Functions
    
    func labeledTextField(isSelected: Bool) {
        errorLabel.isHidden = true
        
        if isSelected {
            nameLabel.textColor = UIColor.scooped.scoopDarkGreen
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.scooped.scoopDarkGreen.cgColor
        } else {
            textField.layer.borderWidth = 1

            if let text = textField.text, !text.isEmpty {
                nameLabel.textColor = UIColor.scooped.offBlack
                textField.layer.borderColor = UIColor.black.cgColor
            } else {
                nameLabel.textColor = UIColor.scooped.mutedGrey
                textField.layer.borderColor = UIColor.scooped.mutedGrey.cgColor
            }
        }
    }

    func displayError() {
        nameLabel.textColor = UIColor.scooped.errorRed2
        textField.layer.borderColor = UIColor.scooped.errorRed.cgColor
        errorLabel.isHidden = false
    }

    func hideError() {
        nameLabel.textColor = (textField.text ?? "").isEmpty ? UIColor.scooped.mutedGrey : UIColor.scooped.offBlack
        textField.layer.borderColor = (textField.text ?? "").isEmpty ? UIColor.scooped.mutedGrey.cgColor : UIColor.black.cgColor
        errorLabel.isHidden = true
    }
    
    func hidesLabel(isHidden: Bool) {
        nameLabel.isHidden = isHidden
    }
    
    func setText(str: String?) {
        textField.text = str
    }
    
    func getText() -> String? {
        return textField.text
    }
    
}
