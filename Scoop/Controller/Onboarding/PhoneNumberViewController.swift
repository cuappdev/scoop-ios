//
//  PhoneNumberViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class PhoneNumberViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let numberTextField = OnboardingTextField()
    private let formatter = PhoneFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "About you")
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            guard let phoneNumber = self.numberTextField.text, self.validateNumber(value: phoneNumber) else {
                self.presentErrorAlert(title: "Error", message: "Please enter a valid phone number.")
                return
            }
            
            Networking.shared.currentUser.phoneNumber =  phoneNumber
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        backButton.isHidden = true
        setupStackView()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }
    
    private func setupStackView() {
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 8.0
        let leadingTrailingInset = 20
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.alignment = .leading
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.center.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 22)
        titleLabel.text = "PHONE NUMBER"
        titleLabel.accessibilityLabel = "phone number"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        stackView.addArrangedSubview(titleLabel)
        
        numberTextField.delegate = self
        numberTextField.font = .systemFont(ofSize: 22)
        numberTextField.textColor = .darkGray
        numberTextField.placeholder = "000-000-0000"
        numberTextField.layer.borderWidth = 1
        numberTextField.layer.borderWidth = textFieldBorderWidth
        numberTextField.layer.borderColor = UIColor.textFieldBorderColor
        numberTextField.layer.cornerRadius = textFieldCornerRadius
        numberTextField.font = UIFont(name: "SFPro", size: 16)
        numberTextField.keyboardType = .phonePad
        stackView.addArrangedSubview(numberTextField)
        numberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func validateNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }
}

// MARK: - UITextFielDelegate
extension PhoneNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        let formatted = formatter.formattedString(from: string)
        textField.text = formatted
        return formatted.isEmpty
    }
}
