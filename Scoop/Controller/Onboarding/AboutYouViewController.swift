//
//  AboutYouViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/11/22.
//

import UIKit

class AboutYouViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let nameTextField = OnboardingTextField()
    private let pronounsTextField = OnboardingTextField()
    private let hometownTextField = OnboardingTextField()
    private let yearTextField = OnboardingTextField()
    
    private let nameLabel = UILabel()
    private let pronounsLabel = UILabel()
    private let hometownLabel = UILabel()
    private let yearLabel = UILabel()
    
    private let pronounsPicker = UIPickerView()
    private let yearPicker = UIPickerView()
    
    private let pronouns = ["He/Him", "She/Her", "They/Them", "Other"]
    private let years = ["Freshman", "Sophomore", "Junior", "Senior", "Grad Student"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "About you")
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            guard let name = self.nameTextField.text, !name.isEmpty,
                  let pronouns = self.pronounsTextField.text, !pronouns.isEmpty,
                  let hometown = self.hometownTextField.text, !hometown.isEmpty,
                  let year = self.yearTextField.text, !year.isEmpty else {
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
        setupLabels()
        backButton.isHidden = true
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
        
    }
    
    private func setupStackView() {
        var stackViewMultiplier = 0.20
        let leadingTrailingInset = 32
        let spacing = 12.0
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
        
        nameTextField.textColor = .offBlack
        nameTextField.delegate = self
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        stackView.addArrangedSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        pronounsPicker.delegate = self
        pronounsPicker.dataSource = self
        
        pronounsTextField.delegate = self
        pronounsTextField.textColor = .offBlack
        pronounsTextField.attributedPlaceholder = NSAttributedString(
            string: "Pronouns",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        pronounsTextField.inputView = pronounsPicker
        pronounsTextField.addTarget(self, action: #selector(updatePronouns), for: .touchDown)
        stackView.addArrangedSubview(pronounsTextField)
        
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        hometownTextField.textColor = .offBlack
        hometownTextField.delegate = self
        hometownTextField.attributedPlaceholder = NSAttributedString(
            string: "Hometown",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        stackView.addArrangedSubview(hometownTextField)
        
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        yearTextField.delegate = self
        yearTextField.textColor = .offBlack
        yearTextField.attributedPlaceholder = NSAttributedString(
            string: "Class Year",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        yearTextField.keyboardType = .numberPad
        yearTextField.inputView = yearPicker
        yearTextField.addTarget(self, action: #selector(updateYear), for: .touchDown)
        stackView.addArrangedSubview(yearTextField)
        
        yearTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        [nameTextField, pronounsTextField, hometownTextField, yearTextField].forEach { text in
            text.layer.borderWidth = textFieldBorderWidth
            text.layer.borderColor = UIColor.textFieldBorderColor.cgColor
            text.layer.cornerRadius = textFieldCornerRadius
            text.font = textFieldFont
        }
    }
    
    private func setupLabels() {
        let labelLeading = 10
        let labelTop = 8
        [nameLabel, pronounsLabel, hometownLabel, yearLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = .scoopDarkGreen
            label.backgroundColor = .white
            label.textAlignment = .center
            label.isHidden = true
            view.addSubview(label)
        }
        
        nameLabel.text = "Name"
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField).inset(-labelTop)
            make.leading.equalTo(nameTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(43)
        }
        
        pronounsLabel.text = "Pronouns"
        pronounsLabel.snp.makeConstraints { make in
            make.top.equalTo(pronounsTextField).inset(-labelTop)
            make.leading.equalTo(pronounsTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(65)
        }
        
        hometownLabel.text = "Hometown"
        hometownLabel.snp.makeConstraints { make in
            make.top.equalTo(hometownTextField).inset(-labelTop)
            make.leading.equalTo(hometownTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(72)
        }
        
        yearLabel.text = "Class Year"
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(yearTextField).inset(-labelTop)
            make.leading.equalTo(yearTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(70)
        }
    }
    
    @objc private func updatePronouns() {
        pronounsTextField.text = pronouns[pronounsPicker.selectedRow(inComponent: 0)]
    }
    
    @objc private func updateYear() {
        yearTextField.text = years[yearPicker.selectedRow(inComponent: 0)]
    }

}

// MARK: - UITextFielDelegate
extension AboutYouViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !(textField == yearTextField || textField == pronounsTextField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.scoopDarkGreen.cgColor
        textField.placeholder = ""
        if textField == nameTextField {
            nameLabel.textColor = .scoopDarkGreen
            nameLabel.isHidden = false
        } else if textField == pronounsTextField {
            pronounsLabel.textColor = .scoopDarkGreen
            pronounsLabel.isHidden = false
        } else if textField == hometownTextField {
            hometownLabel.textColor = .scoopDarkGreen
            hometownLabel.isHidden = false
        } else {
            yearLabel.textColor = .scoopDarkGreen
            yearLabel.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        if textField == nameTextField {
            nameLabel.textColor = .textFieldBorderColor
        } else if textField == pronounsTextField {
            pronounsLabel.textColor = .textFieldBorderColor
        } else if textField == hometownTextField {
            hometownLabel.textColor = .textFieldBorderColor
        } else {
            yearLabel.textColor = .textFieldBorderColor
        }
        
        var responses: [String] = []
        [nameTextField, pronounsTextField, hometownTextField, yearTextField].forEach { textField in
            responses.append(textField.text ?? "")
        }
        
        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
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
            pronounsTextField.text = pronouns[row]
        } else if pickerView == yearPicker {
            yearTextField.text = years[row]
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
