//
//  AboutYouViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/11/22.
//

import UIKit

class AboutYouViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let nameTextField = UITextField()
    private let pronounsTextField = UITextField()
    private let hometownTextField = UITextField()
    private let yearTextField = UITextField()
    private let nextButton = UIButton()
    
    private let pronounsPicker = UIPickerView()
    private let yearPicker = UIPickerView()
    
    private let pronouns = ["He/Him", "She/Her", "They/Them"]
    private let years = ["Freshman", "Sophomore", "Junior", "Senior", "Grad Student"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "About You"
        
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
        
        setupStackView()
        setupNextButton(view: self.view, action: nextAction ?? UIAction(handler: { _ in
            return
        }), button: nextButton)
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
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 22)
        nameLabel.text = "Name"
        nameLabel.textColor = .black
        stackView.addArrangedSubview(nameLabel)
        
        nameTextField.font = .systemFont(ofSize: 22)
        nameTextField.textColor = .darkGray
        nameTextField.placeholder = "name..."
        stackView.addArrangedSubview(nameTextField)
        
        let pronounsLabel = UILabel()
        pronounsLabel.font = .systemFont(ofSize: 22)
        pronounsLabel.text = "Pronouns"
        pronounsLabel.textColor = .black
        stackView.addArrangedSubview(pronounsLabel)
        
        pronounsPicker.delegate = self
        pronounsPicker.dataSource = self
        
        pronounsTextField.delegate = self
        pronounsTextField.font = .systemFont(ofSize: 22)
        pronounsTextField.textColor = .darkGray
        pronounsTextField.placeholder = "pronouns..."
        pronounsTextField.inputView = pronounsPicker
        stackView.addArrangedSubview(pronounsTextField)
        
        let hometownLabel = UILabel()
        hometownLabel.font = .systemFont(ofSize: 22)
        hometownLabel.text = "Hometown"
        hometownLabel.textColor = .black
        stackView.addArrangedSubview(hometownLabel)
        
        hometownTextField.font = .systemFont(ofSize: 22)
        hometownTextField.textColor = .darkGray
        hometownTextField.placeholder = "hometown..."
        stackView.addArrangedSubview(hometownTextField)
        
        let yearLabel = UILabel()
        yearLabel.font = .systemFont(ofSize: 22)
        yearLabel.text = "Class Year"
        yearLabel.textColor = .black
        stackView.addArrangedSubview(yearLabel)
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        yearTextField.delegate = self
        yearTextField.font = .systemFont(ofSize: 22)
        yearTextField.textColor = .darkGray
        yearTextField.placeholder = "year..."
        yearTextField.keyboardType = .numberPad
        yearTextField.inputView = yearPicker
        stackView.addArrangedSubview(yearTextField)
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
