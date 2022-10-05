//
//  PhoneNumberViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class PhoneNumberViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let numberTextField = UITextField()
    private let formatter = PhoneFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "About You"
        
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
       
        setupStackView()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .leading
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(60)
            make.center.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 22)
        titleLabel.text = "Phone Number"
        titleLabel.textColor = .black
        stackView.addArrangedSubview(titleLabel)
        
        numberTextField.delegate = self
        numberTextField.font = .systemFont(ofSize: 22)
        numberTextField.textColor = .darkGray
        numberTextField.placeholder = "000-000-0000"
        numberTextField.keyboardType = .phonePad
        stackView.addArrangedSubview(numberTextField)
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
