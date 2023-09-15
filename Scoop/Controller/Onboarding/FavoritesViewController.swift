//
//  FavoritesViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class FavoritesViewController: OnboardingViewController {
    
    // MARK: - Views
    
    private let stackView = UIStackView()
    private let snackTextField = OnboardingTextField()
    private let songTextField = OnboardingTextField()
    private let stopTextField = OnboardingTextField()
    private let snackLabel = UILabel()
    private let songLabel = UILabel()
    private let stopLabel = UILabel()

    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "Favorites")
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else { return }
    
            guard let snack = self.snackTextField.text, !snack.isEmpty,
                  let song = self.songTextField.text, !song.isEmpty,
                  let stop = self.stopTextField.text, !stop.isEmpty else {
                      self.presentErrorAlert(title: "Error", message: "Please complete all fields.")
                      
                      return
                  }
            
            let snackTrimmed = snack.trimmingCharacters(in: .whitespacesAndNewlines)
            let songTrimmed = song.trimmingCharacters(in: .whitespacesAndNewlines)
            let stopTrimmed = stop.trimmingCharacters(in: .whitespacesAndNewlines)
            self.addPrompt(name: "Snack", placeholder: "Chips", answer: snackTrimmed)
            self.addPrompt(name: "Song", placeholder: "Favorite Song", answer: songTrimmed)
            self.addPrompt(name: "Stop", placeholder: "Gates Hall", answer: stopTrimmed)
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        setupStackView()
        setupLabels()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }
    
    // MARK: - Setup View Functions
    
    private func setupStackView() {
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 4.0
        let textFieldFont = UIFont(name: "SFPro", size: 16)
        let leadingTrailingInset = 32
        let textFieldHeight = 56
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 24
        stackView.alignment = .leading
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.centerY.equalToSuperview()
        }
        
        snackTextField.textColor = .offBlack
        snackTextField.delegate = self
        snackTextField.attributedPlaceholder = NSAttributedString(
            string: "Roadtrip snack",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        stackView.addArrangedSubview(snackTextField)
        
        snackTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        songTextField.textColor = .offBlack
        songTextField.delegate = self
        songTextField.attributedPlaceholder = NSAttributedString(
            string: "Roadtrip song",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        stackView.addArrangedSubview(songTextField)
        
        songTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        stopTextField.textColor = .offBlack
        stopTextField.delegate = self
        stopTextField.attributedPlaceholder = NSAttributedString(
            string: "Roadtrip stop",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        stackView.addArrangedSubview(stopTextField)
        
        stopTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        [songTextField, snackTextField, stopTextField].forEach { text in
            text.layer.borderWidth = textFieldBorderWidth
            text.layer.borderColor = UIColor.textFieldBorderColor.cgColor
            text.layer.cornerRadius = textFieldCornerRadius
            text.font = textFieldFont
        }
    }
    
    private func setupLabels() {
        let labelLeading = 10
        let labelTop = 8
        [songLabel, snackLabel, stopLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = .scoopDarkGreen
            label.backgroundColor = .white
            label.textAlignment = .center
            label.isHidden = true
            view.addSubview(label)
        }
        
        songLabel.text = "Roadtrip song"
        songLabel.snp.makeConstraints { make in
            make.top.equalTo(songTextField).inset(-labelTop)
            make.leading.equalTo(songTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(98)
        }
        
        snackLabel.text = "Roadtrip snack"
        snackLabel.snp.makeConstraints { make in
            make.top.equalTo(snackTextField).inset(-labelTop)
            make.leading.equalTo(snackTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(92)
        }
        
        stopLabel.text = "Roadtrip stop"
        stopLabel.snp.makeConstraints { make in
            make.top.equalTo(stopTextField).inset(-labelTop)
            make.leading.equalTo(stopTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(90)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension FavoritesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.scoopDarkGreen.cgColor
        textField.placeholder = ""
        if textField == snackTextField {
            snackLabel.textColor = .scoopDarkGreen
            snackLabel.isHidden = false
        } else if textField == songTextField {
            songLabel.textColor = .scoopDarkGreen
            songLabel.isHidden = false
        } else {
            stopLabel.textColor = .scoopDarkGreen
            stopLabel.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        if textField == snackTextField {
            snackLabel.textColor = .textFieldBorderColor
        } else if textField == songTextField {
            songLabel.textColor = .textFieldBorderColor
        } else {
            stopLabel.textColor = .textFieldBorderColor
        }
        
        var responses: [String] = []
        [snackTextField, songTextField, stopTextField].forEach { textField in
            responses.append(textField.text ?? "")
        }
        
        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
    }
    
}
