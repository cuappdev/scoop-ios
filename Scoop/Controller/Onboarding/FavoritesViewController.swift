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
    private let snackTextField = LabeledTextField()
    private let songTextField = LabeledTextField()
    private let stopTextField = LabeledTextField()

    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "Favorites")
        
        nextAction = UIAction { [self] _ in
            guard let navCtrl = navigationController else { return }
            
            [snackTextField, songTextField, stopTextField].forEach { textField in
                if (textField.textField.text ?? "").isEmpty {
                    textField.displayError()
                }
            }
            
            guard let snack = snackTextField.textField.text, !snack.isEmpty,
                  let song = songTextField.textField.text, !song.isEmpty,
                  let stop = stopTextField.textField.text, !stop.isEmpty else {
                return
            }
            
            let snackTrimmed = snack.trimmingCharacters(in: .whitespacesAndNewlines)
            let songTrimmed = song.trimmingCharacters(in: .whitespacesAndNewlines)
            let stopTrimmed = stop.trimmingCharacters(in: .whitespacesAndNewlines)
            addPrompt(name: "Snack", placeholder: "Chips", answer: snackTrimmed)
            addPrompt(name: "Song", placeholder: "Favorite Song", answer: songTrimmed)
            addPrompt(name: "Stop", placeholder: "Gates Hall", answer: stopTrimmed)
            delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupTitleLines()
        setupStackView()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }
    
    // MARK: - Setup View Functions
    
    private func setupStackView() {
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
        
        snackTextField.delegate = self
        snackTextField.setup(title: "Roadtrip snack")
        stackView.addArrangedSubview(snackTextField)
        
        snackTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        songTextField.delegate = self
        songTextField.setup(title: "Roadtrip song")
        stackView.addArrangedSubview(songTextField)
        
        songTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        stopTextField.delegate = self
        stopTextField.setup(title: "Roadtrip stop")
        stackView.addArrangedSubview(stopTextField)
        
        stopTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension FavoritesViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
            associatedView.hidesLabel(isHidden: false)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: false)
            if textField.text?.isEmpty ?? true {
                associatedView.hidesLabel(isHidden: true)
            }
        }
        
        var responses: [String] = []
        [snackTextField, songTextField, stopTextField].forEach { textField in
            responses.append(textField.textField.text ?? "")
        }
        
        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
}
