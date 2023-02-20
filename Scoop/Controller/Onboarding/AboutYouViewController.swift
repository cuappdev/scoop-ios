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
    
    private let pronounsPicker = UIPickerView()
    private let yearPicker = UIPickerView()
    
    private let pronouns = ["He/Him", "She/Her", "They/Them"]
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
            NetworkManager.shared.currentUser.hometown = hometown
            NetworkManager.shared.currentUser.grade = year
            
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        setupStackView()
        backButton.isHidden = true
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
        
    }
    
    private func setupStackView() {
        let stackviewMultiplier = 0.10
        let leadingTrailingInset = 20.0
        let spacing = 12.0
        let screenSize = UIScreen.main.bounds
        let labelFont = UIFont(name: "Rambla-Regular", size: 16)
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 8.0
        let textFieldFont = UIFont(name: "SFPro", size: 16)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackviewMultiplier * screenSize.height)
        }
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.text = "NAME"
        nameLabel.accessibilityLabel = "name"
        nameLabel.textColor = .black
        stackView.addArrangedSubview(nameLabel)
        stackView.setCustomSpacing(spacing, after: nameLabel)
        
        nameTextField.textColor = .darkGray
        nameTextField.placeholder = "Enter name..."
        stackView.addArrangedSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let pronounsLabel = UILabel()
        pronounsLabel.text = "PRONOUNS"
        pronounsLabel.accessibilityLabel = "pronouns"
        pronounsLabel.textColor = .black
        stackView.addArrangedSubview(pronounsLabel)
        stackView.setCustomSpacing(spacing, after: pronounsLabel)
        
        pronounsPicker.delegate = self
        pronounsPicker.dataSource = self
        
        pronounsTextField.delegate = self
        pronounsTextField.textColor = .darkGray
        pronounsTextField.placeholder = "Enter pronouns..."
        pronounsTextField.inputView = pronounsPicker
        stackView.addArrangedSubview(pronounsTextField)
        pronounsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let hometownLabel = UILabel()
        hometownLabel.text = "HOMETOWN"
        hometownLabel.accessibilityLabel = "hometown"
        hometownLabel.textColor = .black
        stackView.addArrangedSubview(hometownLabel)
        stackView.setCustomSpacing(spacing, after: hometownLabel)
        
        hometownTextField.textColor = .darkGray
        hometownTextField.placeholder = "Enter town..."
        stackView.addArrangedSubview(hometownTextField)
        hometownTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let yearLabel = UILabel()
        yearLabel.text = "CLASS YEAR"
        yearLabel.accessibilityLabel = "class year"
        yearLabel.textColor = .black
        stackView.addArrangedSubview(yearLabel)
        stackView.setCustomSpacing(spacing, after: yearLabel)
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        yearTextField.delegate = self
        yearTextField.textColor = .darkGray
        yearTextField.placeholder = "Select"
        yearTextField.keyboardType = .numberPad
        yearTextField.inputView = yearPicker
        stackView.addArrangedSubview(yearTextField)
        yearTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        [nameLabel, pronounsLabel, hometownLabel, yearLabel].forEach { label in
            label.font = labelFont
        }
        
        [nameTextField, pronounsTextField, hometownTextField, yearTextField].forEach { text in
            text.layer.borderWidth = textFieldBorderWidth
            text.layer.borderColor = UIColor.textFieldBorderColor
            text.layer.cornerRadius = textFieldCornerRadius
            text.font = textFieldFont
        }
    }
}

// MARK: - UITextFielDelegate
extension AboutYouViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
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
