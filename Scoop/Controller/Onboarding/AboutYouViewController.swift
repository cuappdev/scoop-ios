//
//  AboutYouViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/11/22.
//

import UIKit

class AboutYouViewController: OnboardingViewController {
    
    // MARK: - Views
    
    private let stackView = UIStackView()
    private let nameTextField = LabeledTextField()
    private let pronounsTextField = LabeledTextField()
    private let hometownTextField = LabeledTextField()
    private let yearTextField = LabeledTextField()
    
    private let pronounsPicker = UIPickerView()
    private let yearPicker = UIPickerView()
    
    private let pronouns = PickerOptions.scooped.pronouns
    private let years = PickerOptions.scooped.years

    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "About you")
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            guard let name = self.nameTextField.textField.text, !name.isEmpty,
                  let pronouns = self.pronounsTextField.textField.text, !pronouns.isEmpty,
                  let hometown = self.hometownTextField.textField.text, !hometown.isEmpty,
                  let year = self.yearTextField.textField.text, !year.isEmpty else {
                      self.presentErrorAlert(title: "Error", message: "Please complete all fields.")
                      return
                  }
            NetworkManager.shared.currentUser.pronouns = pronouns
            NetworkManager.shared.currentUser.grade = year
            let hometownTrimmed = hometown.trimmingCharacters(in: .whitespacesAndNewlines)
            self.addPrompt(name: "Hometown", placeholder: "Ithaca", answer: hometownTrimmed)
            
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        setupStackView()
        backButton.isHidden = true
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
        
    }
    
    // MARK: - Setup View Functions
    
    private func setupStackView() {
        var stackViewMultiplier = 0.20
        let leadingTrailingInset = 32
        let screenSize = UIScreen.main.bounds
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 4.0
        let textFieldFont = UIFont(name: "SFPro", size: 16)
        let textFieldHeight = 56
        
        if screenSize.height < 2000 {
            stackViewMultiplier = 0.15
        }
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackViewMultiplier * screenSize.height)
        }
        
        nameTextField.delegate = self
        nameTextField.setup(title: "Name")
        
        stackView.addArrangedSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        pronounsPicker.delegate = self
        pronounsPicker.dataSource = self
        
        pronounsTextField.delegate = self
        pronounsTextField.setup(title: "Pronouns")
        pronounsTextField.textField.addTarget(self, action: #selector(updatePronouns), for: .touchDown)
        stackView.addArrangedSubview(pronounsTextField)
        
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        hometownTextField.delegate = self
        hometownTextField.setup(title: "Hometown")
        stackView.addArrangedSubview(hometownTextField)
        
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        yearTextField.delegate = self
        yearTextField.setup(title: "Class Year")
        yearTextField.textField.keyboardType = .numberPad
        yearTextField.textField.inputView = yearPicker
        yearTextField.textField.addTarget(self, action: #selector(updateYear), for: .touchDown)
        stackView.addArrangedSubview(yearTextField)
        
        yearTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
    }
    
    // MARK: - Helper Functions
    
    @objc private func updatePronouns() {
        pronounsTextField.textField.text = pronouns[pronounsPicker.selectedRow(inComponent: 0)]
    }
    
    @objc private func updateYear() {
        yearTextField.textField.text = years[yearPicker.selectedRow(inComponent: 0)]
    }

}

// MARK: - UITextFielDelegate

extension AboutYouViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !(textField == yearTextField || textField == pronounsTextField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField {
            if let associatedView = onboardingTextField.associatedView as? LabeledTextField {
                associatedView.labeledTextField(isSelected: true)
                associatedView.hidesLabel(isHidden: false)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField {
            if let associatedView = onboardingTextField.associatedView as? LabeledTextField {
                associatedView.labeledTextField(isSelected: false)
                if textField.text?.isEmpty ?? true {
                    associatedView.hidesLabel(isHidden: true)
                }
            }
        }
        
        var responses: [String] = []
        [nameTextField, pronounsTextField, hometownTextField, yearTextField].forEach { textField in
            responses.append(textField.textField.text ?? "")
        }
        
        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
}

// MARK: - UIPickerViewDelegate

extension AboutYouViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pronounsPicker {
            return pronouns[row]
        } else if pickerView == yearPicker {
            return years[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pronounsPicker {
            pronounsTextField.textField.text = pronouns[row]
        } else if pickerView == yearPicker {
            yearTextField.textField.text = years[row]
        }
    }
}

// MARK: - UIPickerViewDataSource

extension AboutYouViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pronounsPicker {
            return pronouns.count
        } else if pickerView == yearPicker {
            return years.count
        }
        return 0
    }
}
