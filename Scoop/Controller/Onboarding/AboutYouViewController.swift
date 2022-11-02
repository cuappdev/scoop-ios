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
            
            Networking.shared.currentUser.name = name
            Networking.shared.currentUser.pronouns = pronouns
            Networking.shared.currentUser.hometown = hometown
            Networking.shared.currentUser.year = year
            
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        setupStackView()
        setBackButtonVisibility(isHidden: true)
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
        
    }
    
    private func setupStackView() {
        let stackviewMultiplier = 0.10
        let leadtrailInset = 20.0
        let spacing = -12
        let screenSize = UIScreen.main.bounds
        let labelFont = UIFont(name: "Rambla-Regular", size: 16)
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 8.0
        let textFieldBorderColor = UIColor(red: 0.584, green: 0.616, blue: 0.647, alpha: 1).cgColor
        let textFieldFont = UIFont(name: "SFPro", size: 16)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadtrailInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackviewMultiplier * screenSize.height)
        }
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.text = "NAME"
        nameLabel.textColor = .black
        stackView.addArrangedSubview(nameLabel)
        
        nameTextField.textColor = .darkGray
        nameTextField.placeholder = "Enter name..."
        stackView.addArrangedSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let pronounsLabel = UILabel()
        pronounsLabel.text = "PRONOUNS"
        pronounsLabel.textColor = .black
        stackView.addArrangedSubview(pronounsLabel)
        
        pronounsPicker.delegate = self
        pronounsPicker.dataSource = self
        
        pronounsTextField.delegate = self
        pronounsTextField.textColor = .darkGray
        pronounsTextField.placeholder = "Enter pronouns..."
        pronounsTextField.inputView = pronounsPicker
        stackView.addArrangedSubview(pronounsTextField)
        pronounsTextField.snp.makeConstraints { make in
            make.top.equalTo(pronounsLabel.snp.bottom).inset(spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let hometownLabel = UILabel()
        hometownLabel.text = "HOMETOWN"
        hometownLabel.textColor = .black
        stackView.addArrangedSubview(hometownLabel)
        
        hometownTextField.textColor = .darkGray
        hometownTextField.placeholder = "Enter town..."
        stackView.addArrangedSubview(hometownTextField)
        hometownTextField.snp.makeConstraints { make in
            make.top.equalTo(hometownLabel.snp.bottom).inset(spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        
        let yearLabel = UILabel()
        yearLabel.text = "CLASS YEAR"
        yearLabel.textColor = .black
        stackView.addArrangedSubview(yearLabel)
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        yearTextField.delegate = self
        yearTextField.textColor = .darkGray
        yearTextField.placeholder = "Select"
        yearTextField.keyboardType = .numberPad
        yearTextField.inputView = yearPicker
        stackView.addArrangedSubview(yearTextField)
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).inset(spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(43)
        }
        [nameLabel, pronounsLabel, hometownLabel, yearLabel].forEach { label in
            label.font = labelFont
        }
        [nameTextField, pronounsTextField, hometownTextField, yearTextField].forEach { text in
            text.layer.borderWidth = textFieldBorderWidth
            text.layer.borderColor = textFieldBorderColor
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
