//
//  LabeledTextField.swift
//  Scoop
//
//  Created by Richie Sun on 9/27/23.
//

import UIKit

class LabeledTextField: UIView {
    
    weak var delegate: UITextFieldDelegate?
    
    private let nameLabel = UILabel()
    let textField = OnboardingTextField()
    
    func setup(title: String, placeholder: String? = nil) {
        var text = title
        if let placeholder = placeholder {
            text = placeholder
        }
        
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        
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
        
        nameLabel.text = " \(title) "
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = .black
        nameLabel.backgroundColor = .white
        nameLabel.isHidden = true
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalTo(textField.snp.top)
        }
    }
    
    func labeledTextField(isSelected: Bool) {
        if isSelected {
            nameLabel.textColor = .scoopDarkGreen
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.scoopDarkGreen.cgColor
        } else {
            nameLabel.textColor = .black
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func hidesLabel(isHidden: Bool) {
        nameLabel.isHidden = isHidden
    }
    
    
}
