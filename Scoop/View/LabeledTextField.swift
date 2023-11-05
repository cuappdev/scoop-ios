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
    
    private let nameLabel = UILabel()
    let textField = OnboardingTextField()
    
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
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        textField.font = .systemFont(ofSize: 16)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.black.cgColor
        textField.delegate = self.delegate
        textField.isUserInteractionEnabled = true
        textField.associatedView = self
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(56)
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
            make.centerY.equalTo(textField.snp.top)
        }
    }
    
    // MARK: - Helper Functions
    
    func labeledTextField(isSelected: Bool) {
        if isSelected {
            nameLabel.textColor = UIColor.scooped.scoopDarkGreen
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.scooped.scoopDarkGreen.cgColor
        } else {
            nameLabel.textColor = UIColor.scooped.mutedGrey
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.black.cgColor
        }
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
