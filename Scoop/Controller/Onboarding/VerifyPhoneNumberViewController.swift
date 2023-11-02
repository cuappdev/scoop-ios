//
//  VerifyPhoneNumberViewController.swift
//  Scoop
//
//  Created by Richie Sun on 4/24/23.
//

import Firebase
import FirebaseAuth
import UIKit

protocol VerificationDelegate: UIViewController {
    func verificationSuccess(phoneNumber: String)
}

class VerifyPhoneNumberViewController: UIViewController {
    
    weak var phoneDelegate: VerificationDelegate?
    private var phoneNumber: String?
    private var verificationID: String?
    
    // MARK: - Views
    
    private let authLabel = UILabel()
    private let codeTextField = UITextField()
    private let messageLabel = UITextView()
    private let noCodeButton = UIButton()
    private let verifyButton = UIButton()
    
    // MARK: - Initializers
    
    init(phoneNumber: String, delegate: VerificationDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.phoneNumber = phoneNumber
        self.phoneDelegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupLabels()
        setupTextFields()
        setupButtons()
        sendVerification()
    }
    
    // MARK: - Setup View Functions
    
    private func setupLabels() {
        guard let phoneNumber = phoneNumber else { return }
        
        authLabel.text = "Verify Phone Number"
        authLabel.font = UIFont(name: "Sen-Regular", size: 24)
        view.addSubview(authLabel)
        
        authLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.text = "Please enter the 4-digit \n verification code sent to \(phoneNumber)"
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.isEditable = false
        messageLabel.textAlignment = .center
        view.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(authLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(100)
        }
    }
    
    private func setupButtons() {
        noCodeButton.setTitle("Didn't recieve a code?", for: .normal)
        noCodeButton.setTitleColor(UIColor.scooped.scoopDarkGreen, for: .normal)
        noCodeButton.addTarget(self, action: #selector(resendOptions), for: .touchUpInside)
        view.addSubview(noCodeButton)
        
        noCodeButton.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        verifyButton.backgroundColor = UIColor.scooped.scoopDarkGreen
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.layer.cornerRadius = 28
        verifyButton.addTarget(self, action: #selector(verifyWithCode), for: .touchUpInside)
        if #available(iOS 15.0, *) {
            verifyButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        } else {
            verifyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        view.addSubview(verifyButton)
        
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(noCodeButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
            make.width.equalTo(150)
        }
    }
    
    private func setupTextFields() {
        codeTextField.layer.cornerRadius = 4
        codeTextField.layer.borderColor = UIColor.scooped.textFieldBorderColor.cgColor
        codeTextField.layer.borderWidth = 1
        codeTextField.delegate = self
        codeTextField.textAlignment = .center
        codeTextField.textContentType = .oneTimeCode
        codeTextField.placeholder = "000000"
        codeTextField.font = .systemFont(ofSize: 24)
        codeTextField.keyboardType = .numberPad
        view.addSubview(codeTextField)
        
        codeTextField.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(56)
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Helper Functions
    
    private func sendVerification() {
        guard let phoneNumber = phoneNumber else { return }
        
        DispatchQueue.main.async {
            PhoneAuthProvider.provider()
                .verifyPhoneNumber("+1 \(phoneNumber)", uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.verificationID = verificationID
                }
        }
    }
    
    @objc private func resendOptions() {
        let alertVC = UIAlertController(title: "Didn't Recieve a Code?", message: "Cancel verifiation or resend code:", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Cancel", style: .default) { UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        
        let resendAction = UIAlertAction(title: "Resend", style: .default) { UIAlertAction in
            self.sendVerification()
        }
        
        alertVC.addAction(closeAction)
        alertVC.addAction(resendAction)
        alertVC.view.tintColor = UIColor.scooped.scoopDarkGreen
        self.present(alertVC, animated: true)
    }
    
    @objc private func verifyWithCode() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID ?? "",
            verificationCode: codeTextField.text ?? "000000"
        )

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                self.presentErrorAlert(title: "Error", message: "Invalid verification code")
                return
            }
            
            let alertVC = UIAlertController(title: "Success!", message: "Successfully verified phone number.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
                guard let phoneNumber = self.phoneNumber else { return }
                
                self.navigationController?.popViewController(animated: true)
                self.phoneDelegate?.verificationSuccess(phoneNumber: phoneNumber)
            }
            
            alertVC.addAction(okAction)
            alertVC.view.tintColor = UIColor.scooped.scoopDarkGreen
            self.present(alertVC, animated: true)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension VerifyPhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numOnly = CharacterSet.decimalDigits
        let characters = CharacterSet(charactersIn: string)
        // Source: https://stackoverflow.com/a/31363255/5278889
        let maxLength = 6
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength && numOnly.isSuperset(of: characters)
    }
}
    
