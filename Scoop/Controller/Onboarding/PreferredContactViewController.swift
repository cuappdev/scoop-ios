//
//  PreferredContactViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class PreferredContactViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let emailButton = UIButton()
    private let phoneButton = UIButton()
    private let phoneLabel = UILabel()
    private let numberTextField = OnboardingTextField()
    private let formatter = PhoneFormatter()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backButton.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "About you")
        setupTitleLines()
        setupStackView()
        setupLabels()
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            guard self.phoneButton.isSelected else {
                NetworkManager.shared.currentUser.phoneNumber = ""
                self.delegate?.didTapNext(navCtrl, nextViewController: nil)
                return
            }
            
            guard let navCtrl = self.navigationController else {
                return
            }
            
            guard let phoneNumber = self.numberTextField.text, self.validateNumber(value: phoneNumber) else {
                self.presentErrorAlert(title: "Error", message: "Please enter a valid phone number.")
                return
            }
            
            NetworkManager.shared.currentUser.phoneNumber = phoneNumber
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        backButton.isHidden = false
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }

    private func setupStackView() {
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 4.0
        let textFieldHeight = 56
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .leading
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.center.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        titleLabel.text = "PREFERRED CONTACT METHOD"
        titleLabel.accessibilityLabel = "preferred contact method"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        stackView.addArrangedSubview(titleLabel)
        
        emailButton.isSelected = true
        emailButton.setTitle("Cornell Email", for: .normal)
        emailButton.setTitleColor(.black, for: .normal)
        emailButton.titleLabel?.font = UIFont(name: "SFPro", size: 16)
        emailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        emailButton.setImage(UIImage(systemName: "circle"), for: .normal)
        emailButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        emailButton.tintColor = .black
        emailButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        emailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        stackView.addArrangedSubview(emailButton)
        
        phoneButton.setTitle("Phone number", for: .normal)
        phoneButton.setTitleColor(.black, for: .normal)
        phoneButton.titleLabel?.font = UIFont(name: "SFPro", size: 16)
        phoneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        phoneButton.setImage(UIImage(systemName: "circle"), for: .normal)
        phoneButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        phoneButton.tintColor = .black
        phoneButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        phoneButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        stackView.addArrangedSubview(phoneButton)
        
        let selectContactAction = UIAction { _ in
            self.emailButton.isSelected.toggle()
            self.phoneButton.isSelected.toggle()
            if self.emailButton.isSelected {
                self.numberTextField.isHidden = true
                self.phoneLabel.isHidden = true
            } else {
                self.numberTextField.isHidden = false
            }
        }
        
        emailButton.addAction(selectContactAction, for: .touchUpInside)
        phoneButton.addAction(selectContactAction, for: .touchUpInside)
        
        numberTextField.isHidden = true
        numberTextField.delegate = self
        numberTextField.font = .systemFont(ofSize: 22)
        numberTextField.textColor = .darkGray
        numberTextField.placeholder = "000-000-0000"
        numberTextField.layer.borderWidth = 1
        numberTextField.layer.borderWidth = textFieldBorderWidth
        numberTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        numberTextField.layer.cornerRadius = textFieldCornerRadius
        numberTextField.font = UIFont(name: "SFPro", size: 16)
        numberTextField.keyboardType = .phonePad
        view.addSubview(numberTextField)
        
        numberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneButton.snp.bottom).inset(-24)
            make.trailing.equalToSuperview().inset(36)
            make.leading.equalTo(phoneButton).inset(34)
            make.height.equalTo(textFieldHeight)
        }
    }
    
    private func setupLabels() {
        let labelLeading = 10
        let labelTop = 8
        phoneLabel.font = .systemFont(ofSize: 12)
        phoneLabel.textColor = .scoopDarkGreen
        phoneLabel.backgroundColor = .white
        phoneLabel.textAlignment = .center
        phoneLabel.isHidden = true
        view.addSubview(phoneLabel)
        
        phoneLabel.text = "Phone"
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(numberTextField).inset(-labelTop)
            make.leading.equalTo(numberTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(44)
        }
    }
    
    private func validateNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }
    
}

extension PreferredContactViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        let formatted = formatter.formattedString(from: string)
        textField.text = formatted
        return formatted.isEmpty
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.scoopDarkGreen.cgColor
        textField.placeholder = ""
        phoneLabel.textColor = .scoopDarkGreen
        phoneLabel.isHidden = false
        return
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        phoneLabel.textColor = .textFieldBorderColor
        return
    }
}
